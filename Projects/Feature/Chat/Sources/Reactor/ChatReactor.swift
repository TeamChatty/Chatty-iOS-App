//
//  ChatReactor.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 2/13/24.
//

import UIKit
import RxSwift
import ReactorKit
import DomainChatInterface
import DomainChat
import FeatureChatInterface

public final class ChatReactor: Reactor {
  private let chatServerConnectUseCase: DefaultChatSTOMPConnectUseCase
  private let chatSendMessageUseCase: DefaultChatSendMessageUseCase
  private let chatRoomSubscribeUseCase: DefaultChatRoomSubscribeUseCase
  private let getChatMessageStreamUseCase: DefaultGetChatMessageStreamUseCase
  private let getChatMessagesUseCase: DefaultGetChatMessgesUseCase
  
  public let roomViewData: ChatRoomViewData
  
  public enum Action {
    case connectChatServer
    case subscribeToChatRoom(roomId: Int)
    case loadMessages
    case sendMessage(MessageContentType)
    case observeChatMessage
    case scrollToUnreadMessage
  }
  
  public enum Mutation {
    case setSocketState(SocketState)
    case setMessages([ChatMessageViewData], Bool)
    case setUnreadMessageIndexPath(IndexPath?)
  }
  
  public struct State {
    var chatRooms: ChatRoomViewData
    var messages: ([ChatMessageViewData], Bool) = ([], false)
    var socketState: SocketState? = nil
    var unreadMessageIndexPath: IndexPath?
  }
  
  public lazy var initialState: State = .init(chatRooms: roomViewData)
  
  public init(chatServerConnectUseCase: DefaultChatSTOMPConnectUseCase, chatSendMessageUseCase: DefaultChatSendMessageUseCase, chatRoomSubscribeUseCase: DefaultChatRoomSubscribeUseCase, getChatMessageStreamUseCase: DefaultGetChatMessageStreamUseCase, getChatMessagesUseCase: DefaultGetChatMessgesUseCase, roomViewData: ChatRoomViewData) {
    self.chatServerConnectUseCase = chatServerConnectUseCase
    self.chatSendMessageUseCase = chatSendMessageUseCase
    self.chatRoomSubscribeUseCase = chatRoomSubscribeUseCase
    self.getChatMessageStreamUseCase = getChatMessageStreamUseCase
    self.getChatMessagesUseCase = getChatMessagesUseCase
    self.roomViewData = roomViewData
  }
}

extension ChatReactor {
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .sendMessage(let message):
      print("메시지 보낸다~")
      chatSendMessageUseCase.execute(roomId: roomViewData.roomId, content: message.textValue, senderId: 6)
      let message: ChatMessageViewData = .init(roomId: roomViewData.roomId, content: .text(message.textValue), senderType: .currentUser, sendTime: Date())
      var messages = currentState.messages
      messages.0 = messageAccessoryCaculated(messages: messages.0, newMessage: message)
      return .just(.setMessages(messages.0, true))
    case .loadMessages:
      return getChatMessagesUseCase.exectue(roomId: roomViewData.roomId)
        .asObservable()
        .flatMap { messages -> Observable<Mutation> in
          let partnerId = self.roomViewData.recieverProfile.userId
          let reversed = messages.reversed()
          let messagesViewData = reversed.map { ChatMessageViewData(roomId: $0.roomId, content: $0.content, senderType: $0.senderId == partnerId ? .participant(.init(name: self.roomViewData.recieverProfile.name, imageURL: self.roomViewData.recieverProfile.profileImageURL)) : .currentUser, sendTime: $0.sendTime) }
          let filteredMessages = self.messageAccessoryFiltered(messages: messagesViewData)
          return .just(.setMessages(filteredMessages, false))
        }
    case .scrollToUnreadMessage:
      return .concat([
        .just(.setUnreadMessageIndexPath(nil)),
        .just(.setUnreadMessageIndexPath(nil))
      ])
    case .connectChatServer:
      return chatServerConnectUseCase.connectSocket()
        .asObservable()
        .flatMap { state -> Observable<Mutation> in
          return .just(.setSocketState(state))
        }
    case .subscribeToChatRoom(let roomId):
      print("STOMP 스톰프 구독 시도")
      chatRoomSubscribeUseCase.execute(roomId: "\(roomId)")
      return .empty()
    case .observeChatMessage:
      return getChatMessageStreamUseCase.execute()
        .asObservable()
        .flatMap { message -> Observable<Mutation> in
          print("메시지 옴?")
          let senderType: ChatParticipantType = message.senderId == self.roomViewData.recieverProfile.userId ? .participant(.init(name: self.roomViewData.recieverProfile.name, imageURL: self.roomViewData.recieverProfile.profileImageURL)) : .currentUser
          var messages = self.currentState.messages
          if case .participant(_) = senderType {
            let messageViewData = ChatMessageViewData(roomId: message.roomId, content: .text(message.content.textValue), senderType: senderType, sendTime: message.sendTime)
            messages.0 = self.messageAccessoryCaculated(messages: messages.0, newMessage: messageViewData)
          }
          return .just(.setMessages(messages.0, true))
        }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setMessages(let messages, let animated):
      newState.messages = (messages, animated)
    case .setUnreadMessageIndexPath(let indexPath):
      newState.unreadMessageIndexPath = indexPath
    case .setSocketState(let state):
      newState.socketState = state
    }
    
    return newState
  }
  
  private func messageAccessoryCaculated(messages: [ChatMessageViewData], newMessage: ChatMessageViewData) -> [ChatMessageViewData] {
    var messages = messages
    var newMessage = newMessage
    if let last = messages.last {
      let previousComponents = last.sendTime?.toMinuteComponents()
      let currentComponents = newMessage.sendTime?.toMinuteComponents()
      // 이전 메시지와 비교하여 설정 변경
      if newMessage.senderType != last.senderType {
        newMessage.accessoryConfig.nicknameAndProfileVisible = true
      } else if previousComponents?.minute != currentComponents?.minute {
        messages[messages.count - 1].accessoryConfig.timeLabelVisible = true
        newMessage.accessoryConfig.nicknameAndProfileVisible = true
        newMessage.accessoryConfig.timeLabelVisible = true
      } else {
        messages[messages.count - 1].accessoryConfig.timeLabelVisible = false
        newMessage.accessoryConfig.timeLabelVisible = true
        newMessage.accessoryConfig.nicknameAndProfileVisible = false
      }
    }
    messages.append(newMessage)
    return messages
  }
  
  private func messageAccessoryFiltered(messages: [ChatMessageViewData]) -> [ChatMessageViewData] {
    var newMessages = messages

    // 초기 설정은 첫 번째 메시지의 설정을 기준으로 함
    guard !newMessages.isEmpty else {
        return newMessages
    }
  
    // 첫 번째 메시지의 설정은 항상 false로 설정
    newMessages[0].accessoryConfig = .init(timeLabelVisible: true, nicknameAndProfileVisible: true)
    
    // 이후 메시지들에 대해 설정 조정
    for i in 1..<newMessages.count {
      let previousComponents = newMessages[i - 1].sendTime?.toMinuteComponents()
      let currentComponents = newMessages[i].sendTime?.toMinuteComponents()
      // 이전 메시지와 비교하여 설정 변경
      if newMessages[i].senderType != newMessages[i - 1].senderType {
        newMessages[i].accessoryConfig.nicknameAndProfileVisible = true
      } else if previousComponents?.minute != currentComponents?.minute {
        newMessages[i - 1].accessoryConfig.timeLabelVisible = true
        newMessages[i].accessoryConfig.timeLabelVisible = true
      } else {
        newMessages[i-1].accessoryConfig.timeLabelVisible = false
        newMessages[i].accessoryConfig.timeLabelVisible = true
        newMessages[i].accessoryConfig.nicknameAndProfileVisible = false
        }
    }
    
    return newMessages
  }
}
