//
//  FeatureChatDependecyProvider.swift
//  FeatureChatInterface
//
//  Created by HUNHIE LEE on 2/16/24.
//

import Foundation
import DomainChat
import DomainUser

public protocol FeatureChatDependecyProvider {
  func makeChatServerConnectUseCase() -> DefaultChatSTOMPConnectUseCase
  func makeGetChatRoomListUseCase() -> DefaultGetChatRoomListUseCase
  func makeChatRoomSubscribeUseCase() -> DefaultChatRoomSubscribeUseCase
  func makeGetChatMessageStreamUseCase() -> DefaultGetChatMessageStreamUseCase
  func makeChatSendMessageUseCase() -> DefaultChatSendMessageUseCase
  func makeGetChatMessagesUseCase() -> DefaultGetChatMessgesUseCase
  func makeGetSomeoneProfileUseCase() -> DefaultGetSomeoneProfileUseCase
}
