//
//  DefaultGetChatRoomListUseCase.swift
//  DomainChat
//
//  Created by HUNHIE LEE on 2/26/24.
//

import Foundation
import RxSwift
import DomainChatInterface

public struct DefaultGetChatRoomListUseCase {
  private let chatAPIRepository: ChatAPIRepositoryProtocol
  
  public init(chatAPIRepository: ChatAPIRepositoryProtocol) {
    self.chatAPIRepository = chatAPIRepository
  }
  
  public func execute() -> Single<[ChatRoom]> {
    return chatAPIRepository.fetchChatRooms()
  }
}
