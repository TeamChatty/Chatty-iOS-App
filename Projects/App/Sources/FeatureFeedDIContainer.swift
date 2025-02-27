//
//  FeatureFeedDIContainer.swift
//  Chatty
//
//  Created by 윤지호 on 4/15/24.
//

import Foundation
import FeatureFeedInterface
import FeatureFeed
import FeatureChatInterface
import FeatureChat
import DomainChatInterface
import DomainChat
import DomainUserInterface
import DomainUser
import DomainCommunity
import SharedDesignSystem


final class FeatureFeedDIContainer: RepositoryDIcontainer, FeatureFeedDependencyProvider {
  
  func getChatCoordinatorDelegate(navigationController: CustomNavigationController) -> ChatCoordinatorDelegate {
     return ChatCoordinator(
       navigationController: navigationController,
       dependencyProvider: AppDIContainer.shared.makeFeatureChatDependencyProvider()
     )
   }
  
  func makeGetFeedUseCase() -> DefaultGetFeedUseCase {
    return DefaultGetFeedUseCase(
      communityAPIRepository: makeCommunityAPIRepository()
    )
  }
  
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
  
  func makeSetBookmarkAndLikeUseCase() -> DefaultSetBookmarkAndLikeUseCase {
    return DefaultSetBookmarkAndLikeUseCase(
      communityAPIRepository: makeCommunityAPIRepository()
    )
  }
  
  func makeSetCommentLikeUseCase() -> DefaultSetCommentLikeUseCase {
    return DefaultSetCommentLikeUseCase(
      communityAPIRepository: makeCommunityAPIRepository()
    )
  }
  
  func makeReportUseCase() -> DefaultReportUseCase {
    return DefaultReportUseCase(
      communityAPIRepository: makeCommunityAPIRepository()
    )
  }
  
  func makeGetCommetUseCase() -> DefaultGetCommetUseCase {
    return DefaultGetCommetUseCase(
      communityAPIRepository: makeCommunityAPIRepository(),
      userProfileRepository: makeUserProfileRepository()
    )
  }
  
  func makeWriteCommentUseCase() -> DefaultWriteCommentUseCase {
    return DefaultWriteCommentUseCase(
      communityAPIRepository: makeCommunityAPIRepository(),
      userProfileRepository: makeUserProfileRepository()
    )
  }
  
  func makeGetMyCommentsUseCase() -> DefaultGetMyCommentsUseCase {
    return DefaultGetMyCommentsUseCase(
      communityAPIRepository: makeCommunityAPIRepository()
    )
  }
  
  func makeCreatChatRoomUseCase() -> DefaultCreatChatRoomUseCase {
    return DefaultCreatChatRoomUseCase(chatAPIRepository: makeChatAPIRepository())
  }
  
  
  func makeGetSomeoneProfileUseCaseTemp() -> DefaultGetSomeoneProfileUseCaseTemp {
    return DefaultGetSomeoneProfileUseCaseTemp(
      userAPIRepository: makeUserAPIRepository()
    )
  }
}
