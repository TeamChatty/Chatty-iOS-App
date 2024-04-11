//
//  SettingPhoneAuthenticationCoordinator.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/11/24.
//
//
//import UIKit
//import FeatureProfileInterface
//import Shared
//import SharedDesignSystem
//
//public final class SettingPhoneAuthenticationCoordinator: BaseCoordinator {
//  public override var type: CoordinatorType {
//    return .setting(.changePhoneNumber)
//  }
//  
//  private let dependencyProvider: FeatureProfileDependencyProvider
//  
//  public init(navigationController: CustomNavigationController, dependencyProvider: FeatureProfileDependencyProvider) {
//    self.dependencyProvider = dependencyProvider
//    super.init(navigationController: navigationController)
//  }
//  
//  deinit {
//    print("해제됨: SettingPhoneAuthenticationCoordinator")
//  }
//   
//  public func start(type: OnboardingAuthType) {
////    let onboardingPhoneAuthenticationReactor = SettingPhoneAuthenticationReactor(
////      type: type,
////      sendVerificationCodeUseCase: dependencyProvider.makeSendVerificationCodeUseCase(),
////      getDeviceIdUseCase: dependencyProvider.makeGetDeviceIdUseCase(),
////      signUseCase: dependencyProvider.makeSignUseCase(), getUserDataUseCase: dependencyProvider.makeGetProfileDataUseCase()
////    )
////    let onboardingPhoneNumberEntryController = SettingPhoneNumberEntryController(reactor: onboardingPhoneAuthenticationReactor)
////    onboardingPhoneNumberEntryController.delegate = self
////    navigationController.pushViewController(onboardingPhoneNumberEntryController, animated: true)
//  }
//}
//
//extension SettingPhoneAuthenticationCoordinator: SettingPhoneAuthenticationDelegate {
//  public func pushToVerificationCodeEntryView(_ reactor: SettingPhoneAuthenticationReactor?) {
////    guard let reactor else { return }
////    let onboardingVerificationCodeEntryController = SettingVerificationCodeEntryController(reactor: reactor)
////    onboardingVerificationCodeEntryController.delegate = self
////    navigationController.pushViewController(onboardingVerificationCodeEntryController, animated: true)
//  }
//  
//  public func pushToNickNameView() {
////    let onboardingNickNameCoordinator = SettingNickNameCoordinator(navigationController: navigationController, dependencyProvider: dependencyProvider)
////    onboardingNickNameCoordinator.start()
////    
////    childCoordinators.append(onboardingNickNameCoordinator)
//  }
//}
