//
//  FeedMainCoordinator.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/15/24.
//

import UIKit
import Shared
import SharedDesignSystem
import SharedUtil
import FeatureFeedInterface

import RxSwift
public final class FeedMainCoordinator: BaseCoordinator, FeedMainCoordinatorProtocol {
  public override var type: CoordinatorType {
    .feed
  }
  
  private let featureProfileDependencyProvider: FeatureFeedDependencyProvider

  public init(navigationController: CustomNavigationController, featureProfileDependencyProvider: FeatureFeedDependencyProvider) {
    self.featureProfileDependencyProvider = featureProfileDependencyProvider
    super.init(navigationController: navigationController)
  }
  
  deinit {
    print("해제됨: FeedMainCoordinator")
  }
  
  let disposeBag = DisposeBag()
  public override func start() {
    let reactor = FeedMainReactor()
    let feedMainController = FeedMainController(reactor: reactor)
    feedMainController.delegate = self
    navigationController.pushViewController(feedMainController, animated: true)
    
    let useCase = featureProfileDependencyProvider.makeWriteFeedUseCase()
    
    let images: [Data] = [
      Images.bell.image,
      Images.bell.image,
      Images.bell.image,
      Images.bell.image,
    ].map { $0.toProfileRequestData() }
    
    let a = useCase.execute(title: "1", content: "dawd", images: images)
    a.subscribe(onNext: { feed in
        print(feed)
      })
      .disposed(by: disposeBag)
  }
}

extension FeedMainCoordinator: FeedMainControllerDelegate {
  func pushToNotificationView() {
    print("push - NotificationView")
  }
  
  func pushToFeedProfileView() {
    print("push - FeedProfileView")
  }
  
  
}
