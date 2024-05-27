//
//  FeatureDependencyProvider.swift
//  Feature
//
//  Created by HUNHIE LEE on 2/2/24.
//

import Foundation
import FeatureOnboardingInterface
import FeatureLive
import FeatureChatInterface
import FeatureProfileInterface
import FeatureFeed

public protocol FeatureDependencyProvider {
  func makeFeatureOnboardingDependencyProvider() -> FeatureOnboardingDependencyProvider
  func makeFeatureLiveDependencyProvider() -> any FeatureLiveDependencyProvider
  func makeFeatureProfileDependencyProvider() -> FeatureProfileDependencyProvider
  func makeFeatureChatDependencyProvider() -> FeatureChatDependecyProvider
  func makeFeatureFeedDependencyProvider() -> any FeatureFeedDependencyProvider
}
