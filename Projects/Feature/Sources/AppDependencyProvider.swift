//
//  AppDependencyProvider.swift
//  Feature
//
//  Created by HUNHIE LEE on 2/2/24.
//

import Foundation
import DomainAuth
import DomainUser

import FeatureOnboardingInterface
import FeatureChatInterface
import FeatureLive
import FeatureProfileInterface
import FeatureFeedInterface
import FeatureFeed
import SharedDesignSystem

public protocol AppDependencyProvider {
  func makeFeatureOnboardingDependencyProvider() -> FeatureOnboardingDependencyProvider
  func makeFeatureLiveDependencyProvider() -> any FeatureLiveDependencyProvider
  func makeFeatureProfileDependencyProvider() -> FeatureProfileDependencyProvider
  func makeFeatureChatDependencyProvider() -> any FeatureChatDependecyProvider
  func makeFeatureFeedDependencyProvider() -> any FeatureFeedDependencyProvider
  
  func makeValiateAccessTokenUseCase() -> DefaultValidateAccessTokenUseCase
  func makeGetAccessTokenUseCase() -> DefaultGetAccessTokenUseCase
  func makeGetProfileUseCase() -> DefaultGetUserProfileUseCase
}
