//
//  AppDependencyProvider.swift
//  Feature
//
//  Created by HUNHIE LEE on 2/2/24.
//

import Foundation
import FeatureOnboardingInterface
import FeatureChatInterface
import DomainAuth
import DomainUser
import FeatureLiveInterface
import FeatureProfileInterface
import FeatureFeedInterface

public protocol AppDependencyProvider {
  func makeFeatureOnboardingDependencyProvider() -> FeatureOnboardingDependencyProvider
  func makeFeatureLiveDependencyProvider() -> FeatureLiveDependencyProvider
  func makeFeatureProfileDependencyProvider() -> FeatureProfileDependencyProvider
  func makeFeatureChatDependencyProvider() -> FeatureChatDependecyProvider
  func makeFeatureFeedDependencyProvider() -> FeatureFeedDependencyProvider
  
  func makeValiateAccessTokenUseCase() -> DefaultValidateAccessTokenUseCase
  func makeGetAccessTokenUseCase() -> DefaultGetAccessTokenUseCase
  func makeGetProfileUseCase() -> DefaultGetUserDataUseCase
}
