//
//  AppCoordinator.swift
//  Feature
//
//  Created by walkerhilla on 12/25/23.
//

import UIKit
import Shared
import SharedDesignSystem
import FeatureOnboarding
import RxSwift
import RxBlocking

public final class AppCoordinator: BaseCoordinator, AppFlowDelegate {
  public override var type: CoordinatorType {
    return .app
  }
  
  public var window: UIWindow
  
  private let appDependencyProvider: AppDependencyProvider
  
  private let disposeBag = DisposeBag()
  
  public init(window: UIWindow, navigationController: CustomNavigationController, featureDependencyProvider: AppDependencyProvider) {
    self.window = window
    self.appDependencyProvider = featureDependencyProvider
    super.init(navigationController: navigationController)
    self.appFlowControl.delegete = self
  }
  
  public override func start() {
    let validateAccessTokenUseCase = appDependencyProvider.makeValiateAccessTokenUseCase()
    let getProfileDataUseCase = appDependencyProvider.makeGetProfileUseCase()
    
    do {
      let isValid = try validateAccessTokenUseCase.execute().toBlocking().single()
      let profile = try getProfileDataUseCase.executeSingle().toBlocking().single()
      
      if isValid {
        if profile.authority == .anonymous {
//          self.showOnboardingFlow()
          self.showMainFlow()
        }
        if profile.authority == .user {
          self.showMainFlow()
        }
      } else {
        // 유효성 검사 실패 처리
        print("자동 로그인 실패! 온보딩으로~")
//        self.showOnboardingFlow()
        self.showMainFlow()
      }
    } catch {
      print("에러 처리: \(error)")
//      self.showOnboardingFlow()
      self.showMainFlow()

    }
  }
  
  public func showOnboardingFlow() {
    let onboardingCoordinator = OnboardingRootCoordinator(
      navigationController: navigationController,
      dependencyProvider: appDependencyProvider.makeFeatureOnboardingDependencyProvider()
    )
    
    childCoordinators.append(onboardingCoordinator)
    onboardingCoordinator.start()
    
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
  }
  
  public func showOnboardingProfileFlow() {
    let onboardingNicknameCoordinator = OnboardingNickNameCoordinator(navigationController: navigationController, dependencyProvider: appDependencyProvider.makeFeatureOnboardingDependencyProvider())
    onboardingNicknameCoordinator.start()
    
    childCoordinators.removeAll()
    childCoordinators.append(onboardingNicknameCoordinator)
    
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
  }
  
  public func showMainFlow() {
    navigationController.setCustomNavigationBarHidden(true, animated: false)
    let mainCoordinator = MainTabBarCoordinator(navigationController, appDependencyProvider: appDependencyProvider)
    mainCoordinator.start()
    
    childCoordinators.removeAll()
    childCoordinators.append(mainCoordinator)
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
  }
}
