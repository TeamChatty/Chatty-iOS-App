//
//  FeatureOnboardingDependencyProvider.swift
//  FeatureOnboardingInterface
//
//  Created by HUNHIE LEE on 2/2/24.
//

import Foundation
import DomainAuth
import DomainUser

public protocol FeatureOnboardingDependencyProvider {
  func makeSendVerificationCodeUseCase() -> DefaultSendVerificationCodeUseCase
  func makeGetDeviceIdUseCase() -> DefaultGetDeviceIdUseCase
  func makeSignUseCase() -> DefaultSignUseCase
  
  func makeSaveProfileNicknameUseCase() -> DefaultSaveProfileNicknameUseCase
  func makeSaveProfileDataUseCase() -> DefaultSaveProfileDataUseCase
  func makeGetProfileDataUseCase() -> DefaultGetUserDataUseCase
  
  func makeGetAllInterestsUseCase() -> DefaultGetAllInterestsUseCase
}
