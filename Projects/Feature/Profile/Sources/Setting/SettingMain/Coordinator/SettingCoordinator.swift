//
//  SettingCoordinator.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/11/24.
//

import UIKit
import PhotosUI
import Mantis
import Shared
import SharedDesignSystem
import FeatureProfileInterface

public final class SettingCoordinator: BaseCoordinator, SettingCoordinatorProtocol {
  public override var type: CoordinatorType {
    .setting(.main)
  }
  
  private let featureProfileDependencyProvider: FeatureProfileDependencyProvider

  public init(navigationController: CustomNavigationController, featureProfileDependencyProvider: FeatureProfileDependencyProvider) {
    self.featureProfileDependencyProvider = featureProfileDependencyProvider
    super.init(navigationController: navigationController)
  }
  
  public override func start() {
    let reactor = SettingReactor(logoutUseCase: featureProfileDependencyProvider.makeLogoutUseCase())
    let settingController = SettingController(reactor: reactor)
    settingController.delegate = self
    navigationController.pushViewController(settingController, animated: true)
  }
}

extension SettingCoordinator: SettingControllerDelegate {
  func pushNotificationView() {
    let reactor = SettingNotificationReactor(getNotificationCheckedData: featureProfileDependencyProvider.makeGetNotificationCheckedData(), saveNotificationBoolean: featureProfileDependencyProvider.makeSaveNotificationBoolean())
    let settingNotificationcontroller = SettingNotificationController(reactor: reactor)
//    settingNotificationcontroller.delegate = self
    navigationController.pushViewController(settingNotificationcontroller, animated: true)
  }
  
  func pushPhoneNumberChangeView() {
//    let reactor = SettingPhoneNumberReactor()
//    let settingPhoneNumberController = SettingPhoneNumberController(reactor: reactor)
////    settingPhoneNumberController.delegate = self
//    navigationController.pushViewController(settingPhoneNumberController, animated: true)
  }
  
  func pushAccountRemoveView() {
    let reactor = SettingRemoveAccountReactor()
    let settingRemoveAccountController = SettingRemoveAccountController(reactor: reactor)
    settingRemoveAccountController.delegate = self
    navigationController.pushViewController(settingRemoveAccountController, animated: true)
  }
  
  func logoutSwitchToOnboading() {
    print("logout - 1 ==>")
    appFlowControl.delegete?.showOnboardingFlow()
  }
}

extension SettingCoordinator: SettingRemoveAccountControllerDelegate {
  func pushToSettingNotificationView() {
    DispatchQueue.main.async {
      _ = self.navigationController.popViewController(animated: true)
      self.pushNotificationView()
    }
  }
  
  func successRemoveAccount() {
    appFlowControl.delegete?.showOnboardingFlow()
  }
}
