//
//  ChatSTOMPService.swift
//  DataNetworkInterface
//
//  Created by HUNHIE LEE on 2/15/24.
//

import Foundation
import RxSwift
import DomainChatInterface

public protocol ChatSTOMPService {
  func connectSocket(token: String) -> PublishSubject<SocketState>
  func socketObserver() -> PublishSubject<ChatMessage>
  func send(_ router: ChatSTOMPRouter)
  func subscribe(to: String)
}
