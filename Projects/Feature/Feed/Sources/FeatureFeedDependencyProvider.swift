// This is for Tuist
import Foundation
import SharedDesignSystem

import DomainCommunity
import DomainChat
import DomainUser
import FeatureChatInterface


public protocol FeatureFeedDependencyProvider {
  associatedtype ChatCoordinatorDelegate
  var navigationController: CustomNavigationController { get }
  func getChatCoordinatorDelegate() -> ChatCoordinatorDelegate
  func getChatCoordinatorDelegate2(navigationController: CustomNavigationController) -> ChatCoordinatorDelegate
  
  func makeGetFeedsPageUseCase() -> DefaultGetFeedsPageUseCase
  func makeWriteFeedUseCase() -> DefaultWriteFeedUseCase
  func makeSetBookmarkAndLikeUseCase() -> DefaultSetBookmarkAndLikeUseCase
  func makeSetCommentLikeUseCase() -> DefaultSetCommentLikeUseCase
  
  func makeReportUseCase() -> DefaultReportUseCase
  func makeGetFeedUseCase() -> DefaultGetFeedUseCase
  
  func makeGetCommetUseCase() -> DefaultGetCommetUseCase
  func makeWriteCommentUseCase() -> DefaultWriteCommentUseCase
  
  func makeGetMyCommentsUseCase() -> DefaultGetMyCommentsUseCase
  
  func makeGetSomeoneProfileUseCaseTemp() -> DefaultGetSomeoneProfileUseCaseTemp
  func makeCreatChatRoomUseCase() -> DefaultCreatChatRoomUseCase
}
