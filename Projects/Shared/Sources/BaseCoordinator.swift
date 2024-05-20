//
//  BaseCoordinator.swift
//  Shared
//
//  Created by walkerhilla on 1/14/24.
//

import Foundation
import SharedDesignSystem

open class BaseCoordinator: Coordinator {
  public weak var finishDelegate: CoordinatorFinishDelegate?
  public var navigationController: CustomNavigationController
  public var childCoordinators: [Coordinator] = []
  public var childViewControllers: ReferenceCounter = .init()
  public var appFlowControl: AppFlowControl = AppFlowControl.shared
  open var type: CoordinatorType {
    return .app
  }
  
  public init(navigationController: CustomNavigationController) {
    self.navigationController = navigationController
    self.navigationController.customDelegate = self
  }
  
  deinit {
    print("Deinitialized \(Swift.type(of: self))")
  }
  
  open func start() {
    
  }
}

extension BaseCoordinator {
  public func setRootViewController(to coordinator: Coordinator, animated: Bool = true) {
    addChildCoordinator(coordinator)
    if let newRootViewController = coordinator.navigationController.viewControllers.last {
      navigationController.setViewControllers([newRootViewController], animated: animated)
    }
  }
  
  public func addChildCoordinator(_ childCoordinator: Coordinator) {
    childCoordinators.append(childCoordinator)
    childCoordinator.finishDelegate = self
  }
  
  public func removeChildCoordinator(_ childCoordinator: Coordinator) {
    for (index, coordinator) in childCoordinators.enumerated() {
      if coordinator === childCoordinator {
        childCoordinators.remove(at: index)
        break
      }
    }
  }
  
  public func deinitRootCoordinator() {
    childCoordinators.removeAll()
    navigationController.viewControllers.removeAll()
  }
}

extension BaseCoordinator: CustomNavigationDelegate {
  public func pushViewController() {
    childViewControllers.increase()
  }
  
  public func popViewController() {
    childViewControllers.decrease()
    if childViewControllers.isReleased {
      finish()
    }
  }
}

extension BaseCoordinator: CoordinatorFinishDelegate {
  public func coordinatorDidFinish(childCoordinator: Coordinator) {
    self.removeChildCoordinator(childCoordinator)
    self.navigationController.customDelegate = self
  }
}
