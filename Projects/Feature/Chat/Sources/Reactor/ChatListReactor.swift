//
//  ChatListReactor.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 2/25/24.
//

import UIKit
import RxSwift
import ReactorKit
import DomainChatInterface
import DomainChat
import FeatureChatInterface

public final class ChatListReactor: Reactor {
  private let chatServerConnectUseCase: DefaultChatSTOMPConnectUseCase
  private let getChatRoomListUseCase: DefaultGetChatRoomListUseCase
  private let chatRoomSubscribeUseCase: DefaultChatRoomSubscribeUseCase
  private let getChatMessageStreamUseCase: DefaultGetChatMessageStreamUseCase
  
  private let disposeBag = DisposeBag()
  
  public enum Action {
    case connectSocketServer
    case loadChatRooms
    case observeChatMessage
    case subscribeChatRoom
  }
  
  public enum Mutation {
    case setSocketState(SocketState)
    case setChatRooms([ChatRoomViewData])
    case setChatMessage(ChatMessageViewData)
  }
  
  public struct State {
    var chatRooms: [ChatRoomViewData]? = nil
    var socketState: SocketState? = nil
  }
  
  public let initialState: State = .init()
  
  public init(chatServerConnectUseCase: DefaultChatSTOMPConnectUseCase, getChatRoomListUseCase: DefaultGetChatRoomListUseCase, chatRoomSubscribeUseCase: DefaultChatRoomSubscribeUseCase, getChatMessageStreamUseCase: DefaultGetChatMessageStreamUseCase) {
    self.chatServerConnectUseCase = chatServerConnectUseCase
    self.getChatRoomListUseCase = getChatRoomListUseCase
    self.chatRoomSubscribeUseCase = chatRoomSubscribeUseCase
    self.getChatMessageStreamUseCase = getChatMessageStreamUseCase
  }
}

extension ChatListReactor {
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loadChatRooms:
      return getChatRoomListUseCase.execute()
        .asObservable()
        .flatMap { rooms -> Observable<Mutation> in
          let _ = rooms.map { room in
            self.chatRoomSubscribeUseCase.execute(roomId: "\(room.roomId)")
          }
          let roomViewData = rooms.map { room in
            let chatRoomActiveStatus = self.computeChatRoomActivationStatus(room: room)
            return ChatRoomViewData(roomId: room.roomId, recieverProfile: .init(userId: room.partnerId, name: room.partnerNickname, profileImageURL: room.partnerImageURL), lastMessage: .init(roomId: room.roomId, content: room.lastMessage?.content ?? .text(""), senderType: .currentUser, sendTime: room.lastMessage?.sendTime), chatRoomActiveStatus: chatRoomActiveStatus, createdTime: room.chatRoomCreatedTime)
          }
          return .just(.setChatRooms(roomViewData))
        }
    case .observeChatMessage:
      return getChatMessageStreamUseCase.execute()
        .asObservable()
        .flatMap { message -> Observable<Mutation> in
          let messageViewData = ChatMessageViewData(roomId: message.roomId, content: .text(message.content.textValue), senderType: .participant(.init(name: "")), sendTime: message.sendTime)
          print("\(message.content.textValue) 메시지 옴~")
          return .just(.setChatMessage(messageViewData))
        }
    case .connectSocketServer:
      return chatServerConnectUseCase.connectSocket()
        .asObservable()
        .flatMap { state -> Observable<Mutation> in
          self.chatServerConnectUseCase.connectSTOMP()
          switch state {
          case .socketConnected:
            return .just(.setSocketState(.socketConnected))
          case .stompConnected:
            return .just(.setSocketState(.stompConnected))
          case .stompDisconnected:
            return .just(.setSocketState(.stompDisconnected))
          }
        }
    case .subscribeChatRoom:
        getChatRoomListUseCase.execute()
        .subscribe(with: self) { owner, rooms in
            let _ = rooms.map { room in
              self.chatRoomSubscribeUseCase.execute(roomId: "\(room.roomId)")
            }
        }
        .disposed(by: disposeBag)
      return .empty()
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newSate = state
    switch mutation {
    case .setSocketState(let status):
      newSate.socketState = status
    case .setChatRooms(let array):
      newSate.chatRooms = array
    case .setChatMessage(let message):
      var chatRooms = currentState.chatRooms
      if let index = chatRooms?.firstIndex(where: { $0.roomId == message.roomId }) {
        chatRooms?[index].lastMessage = message
        
        if let movedItem = chatRooms?.remove(at: index) {
          chatRooms?.insert(movedItem, at: 0)
        }
      }
      newSate.chatRooms = chatRooms
    }
    return newSate
  }
}

extension ChatListReactor {
  private func computeChatRoomActivationStatus(room: ChatRoom) -> ChatRoomType {
    if room.extend {
      return .unlimited
    } else {
      return .temporary(creationTime: room.chatRoomCreatedTime)
    }
  }
}
