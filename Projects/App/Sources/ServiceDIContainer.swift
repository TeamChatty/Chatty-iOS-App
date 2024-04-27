//
//  ServiceDIContainer.swift
//  Chatty
//
//  Created by 윤지호 on 3/7/24.
//

import Foundation
import DataNetwork
import DataStorage

public protocol ServiceDIContainer {
  func makeChatAPIService() -> ChatAPIServiceImpl
  func makeUserAPIService() -> UserAPIServiceImpl
  func makeAuthAPIService() -> AuthAPIServiceImpl
  func makeLiveAPIService() -> LiveAPIServiceImpl
  func makeLiveSocketService() -> LiveSocketServiceImpl
  func makeProfileAPIService() -> ProfileAPIServiceImpl
  func makeInterestAPIService() -> InterestAPIServiceImpl
  func makeUserDefaultsService() -> UserDefaultsService
  func makeCommunityAPIService() -> CommunityAPIServiceImpl
  func makeChatSTOMPService() -> ChatSTOMPServiceImpl
}

extension ServiceDIContainer {
  func makeChatSTOMPService() -> ChatSTOMPServiceImpl {
    return ChatSTOMPServiceImpl.shared
  }
  
  func makeChatAPIService() -> ChatAPIServiceImpl {
    return ChatAPIServiceImpl(
      authAPIService: makeAuthAPIService(),
      keychainService: KeychainService.shared
    )
  }
  
  func makeUserAPIService() -> UserAPIServiceImpl {
    return UserAPIServiceImpl(
      authAPIService: makeAuthAPIService(),
      keychainService: KeychainService.shared
    )
  }
  
  func makeAuthAPIService() -> AuthAPIServiceImpl {
    return AuthAPIServiceImpl(
      keychainService: KeychainService.shared
    )
  }
  
  func makeLiveAPIService() -> LiveAPIServiceImpl {
    return LiveAPIServiceImpl(
      authAPIService: makeAuthAPIService(),
      keychainService: KeychainService.shared
    )
  }
  
  func makeLiveSocketService() -> LiveSocketServiceImpl {
    return LiveSocketServiceImpl(
      keychainService: KeychainService.shared,
      authAPIService: makeAuthAPIService()
    )
  }
  
  func makeProfileAPIService() -> ProfileAPIServiceImpl {
    return ProfileAPIServiceImpl(
      authAPIService: makeAuthAPIService(),
      keychainService: KeychainService.shared
    )
  }
  func makeInterestAPIService() -> InterestAPIServiceImpl {
    return InterestAPIServiceImpl(
      authAPIService: makeAuthAPIService(),
      keychainService: KeychainService.shared
    )
  }
  
  func makeUserDefaultsService() -> UserDefaultsService {
    return UserDefaultsService()
  }
  
  func makeCommunityAPIService() -> CommunityAPIServiceImpl {
    return CommunityAPIServiceImpl(
      authAPIService: makeAuthAPIService(),
      keychainService: KeychainService.shared
    )
  }
}
