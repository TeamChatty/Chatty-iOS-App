//
//  OnboardingPhoneAuthenticationCoordinator.swift
//  FeatureOnboardingInterface
//
//  Created by walkerhilla on 12/29/23.
//

import UIKit
import FeatureOnboardingInterface
import Shared
import SharedDesignSystem

public final class OnboardingPhoneAuthenticationCoordinator: BaseCoordinator {
  public override var type: CoordinatorType {
    return .onboarding(.auth(.signUp))
  }
  
  private let dependencyProvider: FeatureOnboardingDependencyProvider
  
  public init(navigationController: CustomNavigationController, dependencyProvider: FeatureOnboardingDependencyProvider) {
    self.dependencyProvider = dependencyProvider
    super.init(navigationController: navigationController)
  }
  
  deinit {
    print("해제됨: OnboardingPhoneAuthenticationCoordinator")
  }
   
  public func start(type: OnboardingAuthType) {
    let onboardingPhoneAuthenticationReactor = OnboardingPhoneAuthenticationReactor(
      type: type,
      sendVerificationCodeUseCase: dependencyProvider.makeSendVerificationCodeUseCase(),
      getDeviceIdUseCase: dependencyProvider.makeGetDeviceIdUseCase(),
      signUseCase: dependencyProvider.makeSignUseCase(), getUserProfileUseCase: dependencyProvider.makeGetProfileDataUseCase()
    )
    let onboardingPhoneNumberEntryController = OnboardingPhoneNumberEntryController(reactor: onboardingPhoneAuthenticationReactor)
    onboardingPhoneNumberEntryController.delegate = self
    navigationController.pushViewController(onboardingPhoneNumberEntryController, animated: true)
  }
}

extension OnboardingPhoneAuthenticationCoordinator: OnboardingPhoneAuthenticationDelegate {
  public func pushToAccountAccess() {
    let onboardingAccountOwnerCheckCoordinator = OnboardingAccountOwnerCheckCoordinator(navigationController: navigationController, dependencyProvider: dependencyProvider)
    onboardingAccountOwnerCheckCoordinator.start()
    
    childCoordinators.append(onboardingAccountOwnerCheckCoordinator)
  }
  
  public func pushToVerificationCodeEntryView(_ reactor: OnboardingPhoneAuthenticationReactor?) {
    guard let reactor else { return }
    let onboardingVerificationCodeEntryController = OnboardingVerificationCodeEntryController(reactor: reactor)
    onboardingVerificationCodeEntryController.delegate = self
    navigationController.pushViewController(onboardingVerificationCodeEntryController, animated: true)
  }
  
  public func pushToNickNameView() {
    let onboardingNickNameCoordinator = OnboardingNickNameCoordinator(navigationController: navigationController, dependencyProvider: dependencyProvider)
    onboardingNickNameCoordinator.start()
    
    childCoordinators.append(onboardingNickNameCoordinator)
  }
}
