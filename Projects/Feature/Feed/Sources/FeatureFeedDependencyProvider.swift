// This is for Tuist
import Foundation
import FeatureChatInterface
import DomainCommunity
import DomainChat
import DomainUser
import SharedDesignSystem

public protocol FeatureFeedDependencyProvider {
  associatedtype ChatCoordinatorDelegate
  func getChatCoordinatorDelegate(navigationController: CustomNavigationController) -> ChatCoordinatorDelegate
  
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
