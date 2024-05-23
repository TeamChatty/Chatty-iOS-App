//
//  DefaultCreatChatRoomUseCase.swift
//  DomainChat
//
//  Created by 윤지호 on 5/20/24.
//

import Foundation
import RxSwift
import DomainChatInterface

public final class DefaultCreatChatRoomUseCase {
  private let chatAPIRepository: ChatAPIRepositoryProtocol
  
  public init(chatAPIRepository: ChatAPIRepositoryProtocol) {
    self.chatAPIRepository = chatAPIRepository
  }
  
  public func execute(receiverId: Int) -> Observable<ChatRoom> {
    return chatAPIRepository.createChatRoom(receiverId: receiverId)
      .asObservable()
  }
}
