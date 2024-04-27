//
//  ChatSocketRepositoryProtocol.swift
//  DomainChatInterface
//
//  Created by HUNHIE LEE on 2/14/24.
//

import Foundation
import RxSwift

public protocol ChatSTOMPRepositoryProtocol {
  func connectSocket() -> PublishSubject<SocketState>
  func connectSTOMP()
  func socketObserver() -> PublishSubject<ChatMessage>
  func subscribeChatRoom(roomId: String)
  func unsubscribeChatRoom(roomId: String)
  func sendMessage(roomdId: Int, _ type: messageRequestType)
}

public enum messageRequestType {
  case text(String)
  
  public var textValue: String {
    switch self {
    case .text(let string):
      return string
    }
  }
}
