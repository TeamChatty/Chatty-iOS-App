//
//  OnboardingNickNameCoordinator.swift
//  FeatureOnboardingInterface
//
//  Created by 윤지호 on 1/4/24.
//

import UIKit
import Shared
import SharedDesignSystem
import FeatureOnboardingInterface

public final class OnboardingNickNameCoordinator: BaseCoordinator, OnboardingNickNameCoordinatorProtocol {
  public override var type: CoordinatorType {
    .onboarding(.profileUpdate(.nickName))
  }
  
  private let dependencyProvider: FeatureOnboardingDependencyProvider
  
  public init(navigationController: CustomNavigationController, dependencyProvider: FeatureOnboardingDependencyProvider) {
    self.dependencyProvider = dependencyProvider
    super.init(navigationController: navigationController)
  }
  
  deinit {
    print("해제됨: NickName Coordinator")
  }
  
  public override func start() {
    let onboardingNickNameReactor = OnboardingNickNameReactor(
      saveProfileNicknameUseCase: dependencyProvider.makeSaveProfileNicknameUseCase(),
      getUserDataUseCase: dependencyProvider.makeGetProfileDataUseCase()
    )
    let onboardingNickNameController = OnboardingNickNameController(
      reactor: onboardingNickNameReactor
    )
    onboardingNickNameController.delegate = self
    navigationController.pushViewController(onboardingNickNameController, animated: true)
  }
  
  public func pushToProfiles() {
    let onboardingProfileCoordinator = OnboardingProfileCoordinator(
      navigationController: self.navigationController,
      dependencyProvider: dependencyProvider
    )
    
    childCoordinators.append(onboardingProfileCoordinator)
    
    onboardingProfileCoordinator.finishDelegate = self
    onboardingProfileCoordinator.start()
  }
  
  
}
