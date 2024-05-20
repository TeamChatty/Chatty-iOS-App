//
//  OnboardingRootCoordinator.swift
//  FeatureOnboarding
//
//  Created by walkerhilla on 12/26/23.
//

import UIKit
import Shared
import SharedDesignSystem
import FeatureOnboardingInterface

public final class OnboardingRootCoordinator: BaseCoordinator {
  public override var type: CoordinatorType {
    .onboarding(.root)
  }
  
  private let dependencyProvider: FeatureOnboardingDependencyProvider
  
  public init(navigationController: CustomNavigationController, dependencyProvider: FeatureOnboardingDependencyProvider) {
    self.dependencyProvider = dependencyProvider
    super.init(navigationController: navigationController)
  }
   
  public override func start() {
    let onboardingRootController = OnboardingRootController()
    onboardingRootController.delegate = self
    navigationController.setViewControllers([onboardingRootController], animated: false)
  }
  
  deinit {
    self.deinitRootCoordinator()
    print("해제됨: OnboardingRootCoordinator")
  }
}

extension OnboardingRootCoordinator: OnboardingRootDelegate {
  public func presentToTerms() {
    let onboardingTermsController = OnboardingTermsController(reactor: OnboardingTermsReactor())
    onboardingTermsController.modalPresentationStyle = .pageSheet
    onboardingTermsController.delegate = self
    navigationController.present(onboardingTermsController, animated: true)
  }
  
  public func pushToSignIn() {
    let onboardingPhoneAuthenticationCoordinator = OnboardingPhoneAuthenticationCoordinator(
      navigationController: navigationController,
      dependencyProvider: dependencyProvider
    )
    
    childCoordinators.append(onboardingPhoneAuthenticationCoordinator)
    
    onboardingPhoneAuthenticationCoordinator.finishDelegate = self
    onboardingPhoneAuthenticationCoordinator.start(type: .signIn)
  }
  
  public func pushToSignUp() {
    let onboardingPhoneAuthenticationCoordinator = OnboardingPhoneAuthenticationCoordinator(
      navigationController: navigationController,
      dependencyProvider: dependencyProvider
    )
    
    childCoordinators.append(onboardingPhoneAuthenticationCoordinator)
    
    onboardingPhoneAuthenticationCoordinator.finishDelegate = self
    onboardingPhoneAuthenticationCoordinator.start(type: .signUp)
  }
}
