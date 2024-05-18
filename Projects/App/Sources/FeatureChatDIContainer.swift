//
//  FeatureChatDIContainer.swift
//  Chatty
//
//  Created by HUNHIE LEE on 2/16/24.
//

import Foundation
import FeatureChatInterface
import DomainChat
import DomainUser
import DataRepository
import DataNetwork
import DataStorage

final class FeatureChatDIContainer: RepositoryDIcontainer, FeatureChatDependecyProvider {
  func makeGetSomeoneProfileUseCase() -> DomainUser.DefaultGetSomeoneProfileUseCase {
    return DefaultGetSomeoneProfileUseCase(userAPIRepository: makeUserAPIRepository())
  }
  
  func makeGetChatMessagesUseCase() -> DomainChat.DefaultGetChatMessgesUseCase {
    return DefaultGetChatMessgesUseCase(chatAPIRepository: makeChatAPIRepository())
  }
  
  func makeChatSendMessageUseCase() -> DomainChat.DefaultChatSendMessageUseCase {
    return DefaultChatSendMessageUseCase(chatSTOMPRepository: makeChatSTOMPRepository())
  }
  
  func makeGetChatMessageStreamUseCase() -> DomainChat.DefaultGetChatMessageStreamUseCase {
    return DefaultGetChatMessageStreamUseCase(chatSTOMPRepository: makeChatSTOMPRepository())
  }
  
  func makeChatRoomSubscribeUseCase() -> DomainChat.DefaultChatRoomSubscribeUseCase {
    return DefaultChatRoomSubscribeUseCase(chatSTOMPRepository: makeChatSTOMPRepository())
  }
  
  func makeGetChatRoomListUseCase() -> DomainChat.DefaultGetChatRoomListUseCase {
    return DefaultGetChatRoomListUseCase(chatAPIRepository: makeChatAPIRepository())
  }
  
  func makeChatServerConnectUseCase() -> DefaultChatSTOMPConnectUseCase {
    return DefaultChatSTOMPConnectUseCase(chatSTOMPRepository: makeChatSTOMPRepository())
  }
}
