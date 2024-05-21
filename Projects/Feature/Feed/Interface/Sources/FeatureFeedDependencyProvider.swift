// This is for Tuist
import Foundation
import DomainCommunity
import DomainChat
import DomainUser

public protocol FeatureFeedDependencyProvider {
  func makeGetFeedsPageUseCase() -> DefaultGetFeedsPageUseCase
  func makeWriteFeedUseCase() -> DefaultWriteFeedUseCase
  func makeSetBookmarkAndLikeUseCase() -> DefaultSetBookmarkAndLikeUseCase
  func makeSetCommentLikeUseCase() -> DefaultSetCommentLikeUseCase
  
  func makeReportUseCase() -> DefaultReportUseCase
  func makeGetFeedUseCase() -> DefaultGetFeedUseCase
  
  func makeGetCommetUseCase() -> DefaultGetCommetUseCase
  func makeWriteCommentUseCase() -> DefaultWriteCommentUseCase
  
  func makeGetMyCommentsUseCase() -> DefaultGetMyCommentsUseCase
  
  func makeGetSomeoneProfileUseCase() -> DefaultGetSomeoneProfileUseCase
  func makeCreatChatRoomUseCase() -> DefaultCreatChatRoomUseCase
}
