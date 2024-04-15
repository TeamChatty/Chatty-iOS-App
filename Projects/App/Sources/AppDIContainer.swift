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
  
  func makeFeatureLiveDependencyProvider() -> FeatureLiveDependencyProvider {
    return FeatureLiveDIcontainer()
  }
  
  func makeFeatureFeedDependencyProvider() -> FeatureFeedDependencyProvider {
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
  
  func makeGetProfileUseCase() -> DomainUser.DefaultGetUserDataUseCase {
    return DefaultGetUserDataUseCase(userAPIRepository: makeUserAPIRepository(), userDataRepository: makeUserDataRepository())
  }
}
