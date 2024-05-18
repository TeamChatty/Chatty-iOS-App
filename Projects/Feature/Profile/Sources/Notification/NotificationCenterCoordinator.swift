//
//  NotificationCenterCoordinator.swift
//  FeatureProfile
//
//  Created by HUNHIE LEE on 4.05.2024.
//

import Shared
import SharedDesignSystem

public final class NotificationCenterCoordinator: BaseCoordinator {
  public override var type: CoordinatorType {
    return .notification
  }
  
  public override init(navigationController: CustomNavigationController) {
    super.init(navigationController: navigationController)
  }
  
  public override func start() {
    let notificationController = NotificationCenterController()
    navigationController.pushViewController(notificationController, animated: true)
  }
}

extension NotificationCenterController {
  
}
