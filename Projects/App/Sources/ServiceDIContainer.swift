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
  func makeUserAPIService() -> UserAPIServiceImpl
  func makeAuthAPIService() -> AuthAPIServiceImpl
  func makeLiveAPIService() -> LiveAPIServiceImpl
  func makeLiveSocketService() -> LiveSocketServiceImpl
  func makeProfileAPIService() -> ProfileAPIServiceImpl
  func makeInterestAPIService() -> InterestAPIServiceImpl
}

extension ServiceDIContainer {
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
}
