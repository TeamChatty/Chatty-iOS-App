//
//  RepositoryDIcontainer.swift
//  Chatty
//
//  Created by 윤지호 on 2/20/24.
//

import Foundation
import DomainUser
import DomainAuth
import DomainLive
import DomainCommon

import DataNetwork
import DataStorage
import DataRepository

public protocol RepositoryDIcontainer: ServiceDIContainer {
  func makeUserAPIRepository() -> DefaultUserAPIRepository
  func makeAuthAPIRepository() -> DefaultAuthAPIRepository
  func makeKeychainRepository() -> DefaultKeychainReposotory
  func makeUserDataRepository() -> DefaultUserDataRepository
  func makeLiveAPIRepository() -> DefaultLiveAPIRepository
  func makeLiveSocketRepository() -> DefaultLiveSocketRepository
  func makeUserDefaultsRepository() -> DefaultUserDefaultsRepository
  func makeChatSTOMPRepository() -> DefaultChatSTOMPRepository
  func makeChatAPIRepository() -> DefaultChatAPIRepository
}

extension RepositoryDIcontainer {
  func makeUserAPIRepository() -> DefaultUserAPIRepository {
    return DefaultUserAPIRepository(
      userAPIService: makeUserAPIService(),
      profileAPIService: makeProfileAPIService(),
      interestAPIService: makeInterestAPIService()
    )
  }
  
  func makeAuthAPIRepository() -> DefaultAuthAPIRepository {
    return DefaultAuthAPIRepository(
      authAPIService: makeAuthAPIService()
    )
  }
  
  func makeKeychainRepository() -> DefaultKeychainReposotory {
    return DefaultKeychainReposotory(
      keychainService: KeychainService.shared
    )
  }
  
  func makeUserDataRepository() -> DefaultUserDataRepository {
    return DefaultUserDataRepository(
      userDataService: UserProfileService.shared
    )
  }
  
  func makeLiveAPIRepository() -> DefaultLiveAPIRepository {
    return DefaultLiveAPIRepository(
      liveAPIService: makeLiveAPIService()
    )
  }
  
  func makeLiveSocketRepository() -> DefaultLiveSocketRepository {
    return DefaultLiveSocketRepository(
      liveWebSocketService: makeLiveSocketService()
    )
  }
  
  public func makeUserDefaultsRepository() -> DefaultUserDefaultsRepository {
    return DefaultUserDefaultsRepository(
      userDefaultService: makeUserDefaultsService()
      )
  }
  
  func makeChatSTOMPRepository() -> DefaultChatSTOMPRepository {
    return DefaultChatSTOMPRepository(chatSTOMPService: ChatSTOMPServiceImpl.shared)
  }
  
  func makeChatAPIRepository() -> DefaultChatAPIRepository {
    return DefaultChatAPIRepository(
      chatAPIService: makeChatAPIService()
    )
  }
}
