//
//  FeedDetailCoordinator.swift
//  FeatureFeed
//
//  Created by 윤지호 on 5/3/24.
//

import UIKit
import Foundation
import Shared
import SharedDesignSystem

import FeatureFeedInterface
import DomainCommunityInterface
import DomainChatInterface

public protocol FeedDetailCoordinatorProtocol {
  func start(postId: Int)
}

public final class FeedDetailCoordinator: BaseCoordinator, FeedDetailCoordinatorProtocol {
  public override var type: CoordinatorType {
    .feed(.detail)
  }
    
  private let featureFeedDependencyProvider: FeatureFeedDependencyProvider
  
  public init(navigationController: CustomNavigationController, featureFeedDependencyProvider: FeatureFeedDependencyProvider) {
    self.featureFeedDependencyProvider = featureFeedDependencyProvider
    super.init(navigationController: navigationController)
  }
  
  public func start(postId: Int) {
    let reactor = FeedDetailReactor(
      getFeedUseCase: featureFeedDependencyProvider.makeGetFeedUseCase(),
      setBookmarkAndLikeUseCase: featureFeedDependencyProvider.makeSetBookmarkAndLikeUseCase(),
      setCommentLikeUseCase: featureFeedDependencyProvider.makeSetCommentLikeUseCase(),
      reportUseCase: featureFeedDependencyProvider.makeReportUseCase(),
      getCommetUseCase: featureFeedDependencyProvider.makeGetCommetUseCase(),
      writeCommentUseCase: featureFeedDependencyProvider.makeWriteCommentUseCase(),
      postId: postId)
   
    let feedDetailController = FeedDetailController(reactor: reactor)
    
    feedDetailController.delegate = self
    navigationController.pushViewController(feedDetailController, animated: true)
  }
}


extension FeedDetailCoordinator: FeedChatModalControllerDelegate {
  func dismiss() {
    navigationController.dismiss(animated: true)
  }
  
  func startChatting(chatRoom: ChatRoom) {
    navigationController.dismiss(animated: true)
    
    /// Start Mehod
  }
}


extension FeedDetailCoordinator: FeedDetailControllerDelegate {
  func presentStartChatModal(receiverId: Int) {
    let reactor = FeedChatModalReactor(getSomeoneProfileUseCase: featureFeedDependencyProvider.makeGetSomeoneProfileUseCase(), creatChatRoomUseCase: featureFeedDependencyProvider.makeCreatChatRoomUseCase(), someoneId: receiverId)
    let modal = FeedChatModalController(reactor: reactor)
    modal.delegate = self
    
    navigationController.present(modal, animated: true)
  }
  
  func presentReportModal(userId: Int) {
    let reactor = FeedReportReactor(reportUseCase: featureFeedDependencyProvider.makeReportUseCase(), userId: userId)
    let modal = FeedReportModalController(reactor: reactor)
    modal.delegate = self
    
    modal.modalPresentationStyle = .pageSheet
    navigationController.present(modal, animated: true)
  }
  
  
}

extension FeedDetailCoordinator: FeedReportModalControllerDelegate {
  func dismissModal() {
    navigationController.dismiss(animated: true)
  }
  
  func successReport(userId: Int) {
    
  }
}
