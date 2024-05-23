//
//  ChatAPIRepositoryProtocol.swift
//  DomainChatInterface
//
//  Created by HUNHIE LEE on 2/13/24.
//

import Foundation
import RxSwift

public protocol ChatAPIRepositoryProtocol {
  func fetchChatMessages(roomId: Int) -> Single<[ChatMessage]>
  func saveChatMessage(with message: ChatMessage) -> Single<Void>
  func fetchChatRooms() -> Single<[ChatRoom]>
  func fetchChatRoom(roomId: Int) -> Single<ChatRoom>
}
