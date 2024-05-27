//
//  AppDIContainer.swift
//  Chatty
//
//  Created by HUNHIE LEE on 2/2/24.
//

import Foundation
import Feature
import FeatureOnboardingInterface
import FeatureLiveInterface
import FeatureFeedInterface
import FeatureFeed
import FeatureLive
import FeatureProfileInterface
import FeatureChatInterface
import DomainCommon
import DomainUser
import DomainAuth
import DataRepository
import DataNetwork
import DataStorage

final class AppDIContainer: RepositoryDIcontainer, AppDependencyProvider {
  static let shared: AppDIContainer = AppDIContainer()
  
  private init() { }
  
  func makeFeatureOnboardingDependencyProvider() -> FeatureOnboardingDependencyProvider {
    return FeatureOnboardingDIContainer()
  }
  
  func makeFeatureLiveDependencyProvider() -> any FeatureLiveDependencyProvider {
    return FeatureLiveDIcontainer()
  }
  
  func makeFeatureFeedDependencyProvider() -> any FeatureFeedDependencyProvider {
    return FeatureFeedDIContainer()
  }
  
  func makeFeatureProfileDependencyProvider() -> FeatureProfileDependencyProvider {
    return FeatureProfileDIContainer()
  }
  
  func makeFeatureChatDependencyProvider() -> FeatureChatDependecyProvider {
    return FeatureChatDIContainer()
  }
  
  func makeDefaultSaveDeviceTokenUseCase() -> DefaultSaveDeviceTokenUseCase {
    return DefaultSaveDeviceTokenUseCase(keychainRepository: makeKeychainRepository())
  }
  
  func makeDefaultSaveDeviceIdUseCase() -> DefaultSaveDeviceIdUseCase {
    return DefaultSaveDeviceIdUseCase(keychainRepository: makeKeychainRepository())
  }
  
  func makeDefaultGetDeviceIdUseCase() -> DefaultGetDeviceIdUseCase {
    return DefaultGetDeviceIdUseCase(keychainRepository: makeKeychainRepository())
  }
  
  func makeValiateAccessTokenUseCase() -> DomainAuth.DefaultValidateAccessTokenUseCase {
    return DefaultValidateAccessTokenUseCase(authAPIRepository: makeAuthAPIRepository())
  }
  
  func makeGetAccessTokenUseCase() -> DomainAuth.DefaultGetAccessTokenUseCase {
    return DefaultGetAccessTokenUseCase(keychainRepository: makeKeychainRepository())
  }
  
  func makeGetProfileUseCase() -> DomainUser.DefaultGetUserProfileUseCase {
    return DefaultGetUserProfileUseCase(userAPIRepository: makeUserAPIRepository(), userProfileRepository: makeUserProfileRepository())
  }
}
