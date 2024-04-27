//
//  DefaultGetChatMessgesUseCase.swift
//  DomainChat
//
//  Created by HUNHIE LEE on 26.03.2024.
//

import Foundation
import RxSwift
import DomainChatInterface

public struct DefaultGetChatMessgesUseCase {
  private let chatAPIRepository: ChatAPIRepositoryProtocol
  
  public init(chatAPIRepository: ChatAPIRepositoryProtocol) {
    self.chatAPIRepository = chatAPIRepository
  }
  
  public func exectue(roomId: Int) -> Single<[ChatMessage]> {
    return chatAPIRepository.fetchChatMessages(roomId: roomId)
  }
}
