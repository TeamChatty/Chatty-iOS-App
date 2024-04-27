//
//  DefaultChatSTOMPRepository.swift
//  DataRepositoryInterface
//
//  Created by HUNHIE LEE on 2/14/24.
//

import Foundation
import DataNetworkInterface
import DomainChatInterface
import RxSwift
import DataStorageInterface

public struct DefaultChatSTOMPRepository: ChatSTOMPRepositoryProtocol {
  private let chatSTOMPService: any ChatSTOMPService
  private let keychainService: KeychainServiceProtocol
  
  public init(chatSTOMPService: any ChatSTOMPService, keychainService: KeychainServiceProtocol) {
    self.chatSTOMPService = chatSTOMPService
    self.keychainService = keychainService
  }
  
  public func connectSocket() -> PublishSubject<SocketState> {
    let token = keychainService.read(type: .accessToken()) ?? ""
    return chatSTOMPService.connectSocket(token: token)
  }
  
  public func send(_ router: ChatSTOMPRouter) {
    return chatSTOMPService.send(router)
  }
  
  public func socketObserver() -> PublishSubject<ChatMessage> {
    return chatSTOMPService.socketObserver()
  }
  
  public func connectSTOMP() {
    chatSTOMPService.send(.connectToChatServer)
  }
  
  public func subscribeChatRoom(roomId: String) {
    chatSTOMPService.subscribe(to: roomId)
  }
  
  public func unsubscribeChatRoom(roomId: String) {
    chatSTOMPService.send(.unsubsribeFromChatRoom(roomId: roomId))
  }
  
  public func sendMessage(roomdId: Int, _ type: DomainChatInterface.messageRequestType) {
    chatSTOMPService.send(.sendMessage(.init(roomId: roomdId, senderId: 6, receiverId: 13, content: type.textValue)))
  }
  
}
