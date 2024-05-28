//
//  ProfileMainCoordinator.swift
//  FeatureProfileInterface
//
//  Created by 윤지호 on 3/17/24.
//

import Shared
import SharedDesignSystem
import FeatureProfileInterface

public final class ProfileMainCoordinator: BaseCoordinator, ProfileMainCoordinatorProtocol {
  public override var type: CoordinatorType {
    .profile(.main)
  }
  
  private let featureProfileDependencyProvider: FeatureProfileDependencyProvider
  
  public init(navigationController: CustomNavigationController, featureProfileDependencyProvider: FeatureProfileDependencyProvider) {
    self.featureProfileDependencyProvider = featureProfileDependencyProvider
    super.init(navigationController: navigationController)
  }
  
  deinit {
    self.deinitRootCoordinator()
  }
  
  public override func start() {
    let reactor = ProfileMainReactor(getUserDataUseCase: featureProfileDependencyProvider.makeGetProfileDataUseCase())
    let profileMainController = ProfileMainController(reactor: reactor)
    profileMainController.delegate = self
    navigationController.pushViewController(profileMainController, animated: true)
  }
}

extension ProfileMainCoordinator: ProfileMainControllerDelegate {
  func pushNotificationView() {
    let coordinator = NotificationCenterCoordinator(navigationController: navigationController)
//    self.
  }
  
  func pushSettingView() {
    let settingCoordinator = SettingCoordinator(
      navigationController: navigationController,
      featureProfileDependencyProvider: featureProfileDependencyProvider
    )
    childCoordinators.append(settingCoordinator)
    settingCoordinator.finishDelegate = self
    settingCoordinator.start()
  }
  
  func pushProfileEditView() {
    let profileEditMainCoordinator = ProfileEditMainCoordinator(
      navigationController: navigationController,
      featureProfileDependencyProvider: featureProfileDependencyProvider
    )
    childCoordinators.append(profileEditMainCoordinator)
    profileEditMainCoordinator.start()
  }
  
  func pushCashItemsView() {
    print("push possessionItems")

  }
  
  func pushMembershipView() {
    print("push membership")

  }
  
  func pushProblemNotice() {
    print("push problem Notice")

  }
  
  func pushProblemFrequentlyQuestion() {
    print("push problem FrequentlyQuestion")

  }
  
  func pushProblemContactService() {
    print("push problem ContactService")

  }
  
  
}

