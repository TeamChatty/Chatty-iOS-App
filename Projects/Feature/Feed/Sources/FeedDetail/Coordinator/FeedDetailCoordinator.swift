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
      reportUseCase: featureFeedDependencyProvider.makeReportUseCase(),
      postId: postId)
   
    let feedDetailController = FeedDetailController(reactor: reactor)
    
    feedDetailController.delegate = self
    navigationController.pushViewController(feedDetailController, animated: true)
  }
}

extension FeedDetailCoordinator: FeedDetailControllerDelegate {
  func presentReportModal(userId: Int) {
    let reactor = FeedReportReactor(userId: userId)
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
