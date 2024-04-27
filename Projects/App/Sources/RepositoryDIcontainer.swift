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
import DomainCommunity
import DomainCommon

import DataNetwork
import DataStorage
import DataRepository

public protocol RepositoryDIcontainer: ServiceDIContainer {
  func makeUserAPIRepository() -> DefaultUserAPIRepository
  func makeAuthAPIRepository() -> DefaultAuthAPIRepository
  func makeKeychainRepository() -> DefaultKeychainReposotory
  func makeUserProfileRepository() -> DefaultUserProfileRepository
  func makeLiveAPIRepository() -> DefaultLiveAPIRepository
  func makeLiveSocketRepository() -> DefaultLiveSocketRepository
  func makeUserDefaultsRepository() -> DefaultUserDefaultsRepository
  func makeChatSTOMPRepository() -> DefaultChatSTOMPRepository
  func makeChatAPIRepository() -> DefaultChatAPIRepository
  func makeCommunityAPIRepository() -> DefaultCommunityAPIRepository
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
  
  func makeUserProfileRepository() -> DefaultUserProfileRepository {
    return DefaultUserProfileRepository(
      userProfileService: UserProfileService.shared
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
    return DefaultChatSTOMPRepository(chatSTOMPService: makeChatSTOMPService(), keychainService: KeychainService.shared)
  }
  
  func makeChatAPIRepository() -> DefaultChatAPIRepository {
    return DefaultChatAPIRepository(
      chatAPIService: makeChatAPIService()
    )
  }
  
  func makeCommunityAPIRepository() -> DefaultCommunityAPIRepository {
    return DefaultCommunityAPIRepository(
      communityAPIService: makeCommunityAPIService()
    )
  }
}
