//
//  DefaultGetChatMessageStreamUseCase.swift
//  DomainChat
//
//  Created by HUNHIE LEE on 3/4/24.
//

import Foundation
import RxSwift
import DomainChatInterface

public struct DefaultGetChatMessageStreamUseCase {
  private let chatSTOMPRepository: ChatSTOMPRepositoryProtocol
  
  public init(chatSTOMPRepository: ChatSTOMPRepositoryProtocol) {
    self.chatSTOMPRepository = chatSTOMPRepository
  }
  
  public func execute() -> PublishSubject<ChatMessage> {
    return chatSTOMPRepository.socketObserver()
  }
}
