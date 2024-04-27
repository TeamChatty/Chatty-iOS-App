//
//  FeatureFeedDIContainer.swift
//  Chatty
//
//  Created by 윤지호 on 4/15/24.
//

import Foundation
import FeatureFeedInterface
import DomainCommunity

final class FeatureFeedDIContainer: RepositoryDIcontainer, FeatureFeedDependencyProvider {
  
  func makeGetFeedsPageUseCase() -> DefaultGetFeedsPageUseCase {
    return DefaultGetFeedsPageUseCase(
      communityAPIRepository: makeCommunityAPIRepository()
    )
  }
  func makeWriteFeedUseCase() -> DefaultWriteFeedUseCase {
    return DefaultWriteFeedUseCase(
      communityAPIRepository: makeCommunityAPIRepository()
    )
  }
}
