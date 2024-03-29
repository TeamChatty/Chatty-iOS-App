//
//  FeatureChatDIContainer.swift
//  Chatty
//
//  Created by HUNHIE LEE on 2/16/24.
//

import Foundation
import FeatureChatInterface
import DomainChat
import DataRepository
import DataNetwork
import DataStorage

final class FeatureChatDIContainer: RepositoryDIcontainer, FeatureChatDependecyProvider {
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

extension FeatureChatDIContainer {
  func makeChatSTOMPRepository() -> DefaultChatSTOMPRepository {
    return DefaultChatSTOMPRepository(chatSTOMPService: ChatSTOMPServiceImpl.shared)
  }
  
  func makeChatAPIRepository() -> DefaultChatAPIRepository {
    return DefaultChatAPIRepository(
      chatAPIService: ChatAPIServiceImpl(
        authAPIService: AuthAPIServiceImpl(
          keychainService: KeychainService.shared
        ),
        keychainService: KeychainService.shared)
    )
  }
}
