//
//  FeatureDependencyProvider.swift
//  Feature
//
//  Created by HUNHIE LEE on 2/2/24.
//

import Foundation
import FeatureOnboardingInterface
import FeatureLiveInterface
import FeatureChatInterface
import FeatureProfileInterface

public protocol FeatureDependencyProvider {
  func makeFeatureOnboardingDependencyProvider() -> FeatureOnboardingDependencyProvider
  func makeFeatureLiveDependencyProvider() -> FeatureLiveDependencyProvider
  func makeFeatureProfileDependencyProvider() -> FeatureProfileDependencyProvider
  func makeFeatureChatDependencyProvider() -> FeatureChatDependecyProvider
}
