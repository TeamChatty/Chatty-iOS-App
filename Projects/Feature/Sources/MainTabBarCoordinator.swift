//
//  MainTabBarCoordinator.swift
//  Feature
//
//  Created by walkerhilla on 12/25/23.
//

import UIKit
import Shared
import SharedDesignSystem
import FeatureLive
import FeatureLiveInterface
import FeatureChat
import FeatureChatInterface
import FeatureProfile

final class MainTabBarCoordinator: BaseCoordinator {
  override var type: CoordinatorType {
   return .tab
  }

  private let appDependencyProvider: AppDependencyProvider
  
  public init(_ navigationController: CustomNavigationController, appDependencyProvider: AppDependencyProvider) {
    self.appDependencyProvider = appDependencyProvider
    super.init(navigationController: navigationController)
  }
  
  override func start() {
    let liveTabCoordinator = LiveMainCoordinator(navigationController: CustomNavigationController(), featureLiveDependencyProvider: appDependencyProvider.makeFeatureLiveDependencyProvider())
    liveTabCoordinator.start()
    
    let chatTabCoordinator = ChatCoordinator(navigationController: CustomNavigationController(), dependencyProvider: appDependencyProvider.makeFeatureChatDependencyProvider())
    chatTabCoordinator.start()
    
    let profileTabCoordinator = ProfileMainCoordinator(navigationController: CustomNavigationController(), featureProfileDependencyProvider: appDependencyProvider.makeFeatureProfileDependencyProvider())
    profileTabCoordinator.start()
    
    let tabBarController = MainTabBarController(tabNavigationControllers: [
      .live: liveTabCoordinator.navigationController,
      .chat: chatTabCoordinator.navigationController,
      .myChatty: profileTabCoordinator.navigationController
    ])
    
    childCoordinators.append(liveTabCoordinator)
    childCoordinators.append(chatTabCoordinator)
    childCoordinators.append(profileTabCoordinator)
    
    navigationController.setViewControllers([tabBarController], animated: false)
  }
}
