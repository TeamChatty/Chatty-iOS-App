//
//  DefaultGetChatRoomUseCase.swift
//  DomainChat
//
//  Created by HUNHIE LEE on 23.04.2024.
//

import Foundation
import RxSwift
import DomainChatInterface

public struct DefaultGetChatRoomUseCase {
  private let chatAPIRepository: ChatAPIRepositoryProtocol
  
  public init(chatAPIRepository: ChatAPIRepositoryProtocol) {
    self.chatAPIRepository = chatAPIRepository
  }
  
  public func exectue(roomId: Int) -> Single<ChatRoom> {
    return chatAPIRepository.fetchChatRoom(roomId: roomId)
  }
}
