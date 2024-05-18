//
//  OnboardingAccountOwnerCheckCoordinator.swift
//  FeatureOnboardingInterface
//
//  Created by HUNHIE LEE on 1/30/24.
//

import UIKit
import Shared
import SharedDesignSystem
import FeatureOnboardingInterface

public protocol AccountOwnerCheckDelegate: AnyObject {
  func pushToQuestion(step: AccountSecurityQuestionType)
  func pushToCompleted()
  func pushToFailed(type: AccountAccessFailedType)
  func pushToCreateAccount()
}

public final class OnboardingAccountOwnerCheckCoordinator: BaseCoordinator {
  public override var type: CoordinatorType {
   return .onboarding(.newDeviceAccess(.accountOwnerCheck))
  }
  
  private let dependencyProvider: FeatureOnboardingDependencyProvider
  
  public init(navigationController: CustomNavigationController, dependencyProvider: FeatureOnboardingDependencyProvider) {
    self.dependencyProvider = dependencyProvider
    super.init(navigationController: navigationController)
  }
  
  public override func start() {
    let onboardingAccountOwnerCheckController = OnboardingAccountOwnerCheckController(reactor: .init(getAuthCheckProblemUseCase: dependencyProvider.makeGetAuthCheckQuestionUseCase(), getAuthCheckProfileUseCase: dependencyProvider.makeGetAuthCheckProfileUseCase(), postAuthCheckAnswerUseCase: dependencyProvider.makePostAuthCheckAnswerUseCase()))
    onboardingAccountOwnerCheckController.delegate = self
    navigationController.pushViewController(onboardingAccountOwnerCheckController, animated: true)
  }
}

extension OnboardingAccountOwnerCheckCoordinator: AccountOwnerCheckDelegate {
  public func pushToQuestion(step: AccountSecurityQuestionType) {
    let accountSecurityQuestionController = AccountSecurityQuestionController(reactor: .init(getAuthCheckProblemUseCase: dependencyProvider.makeGetAuthCheckQuestionUseCase(), getAuthCheckProfileUseCase: dependencyProvider.makeGetAuthCheckProfileUseCase(), postAuthCheckAnswerUseCase: dependencyProvider.makePostAuthCheckAnswerUseCase()), step: step)
    accountSecurityQuestionController.delegate = self
    navigationController.pushViewController(accountSecurityQuestionController, animated: true)
  }
  
  public func pushToCompleted() {
    let accountAccessCompletedController = AccountAccessCompletedController()
    navigationController.setViewControllers([accountAccessCompletedController], animated: true)
  }
  
  public func pushToFailed(type: AccountAccessFailedType) {
    let accountAccessFailedController = AccountAccessFailedController(failedType: type)
    navigationController.pushViewController(accountAccessFailedController, animated: true)
  }
  
  public func pushToCreateAccount() {
    
  }
}
