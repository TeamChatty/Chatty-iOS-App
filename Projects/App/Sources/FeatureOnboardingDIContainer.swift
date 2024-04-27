//
//  FeatureOnboardingDIContainer.swift
//  Chatty
//
//  Created by HUNHIE LEE on 2/2/24.
//

import Foundation
import DomainAuth
import DomainUser
import FeatureOnboardingInterface

final class FeatureOnboardingDIContainer: RepositoryDIcontainer, FeatureOnboardingDependencyProvider {
  func makeGetAuthCheckQuestionUseCase() -> DomainAuth.DefaultGetAuthCheckQuestionUseCase {
    return DefaultGetAuthCheckQuestionUseCase(
      authAPIRepository: makeAuthAPIRepository(),
      userProfileRepository: makeUserProfileRepository()
    )
  }
  
  func makeSignUseCase() -> DefaultSignUseCase {
    return DefaultSignUseCase(
      userAPIRepository: makeUserAPIRepository(),
      keychainRepository: makeKeychainRepository(), 
      getAllInterestsUseCase: makeGetAllInterestsUseCase()
    )
  }
  
  func makeSendVerificationCodeUseCase() -> DefaultSendVerificationCodeUseCase {
    return DefaultSendVerificationCodeUseCase(
      authAPIRepository: makeAuthAPIRepository(),
      keychainRepository: makeKeychainRepository(),
      userProfileRepository: makeUserProfileRepository())
  }
  
  func makeGetDeviceIdUseCase() -> DefaultGetDeviceIdUseCase {
    return DefaultGetDeviceIdUseCase(
      keychainRepository: makeKeychainRepository()
    )
  }
  
  func makeSaveProfileNicknameUseCase() -> DefaultSaveProfileNicknameUseCase {
    return DefaultSaveProfileNicknameUseCase(
      userAPIRepository: makeUserAPIRepository(),
      userProfileRepository: makeUserProfileRepository()
    )
  }
  
  func makeSaveProfileDataUseCase() -> DefaultSaveProfileDataUseCase {
    return DefaultSaveProfileDataUseCase(
      userAPIRepository: makeUserAPIRepository(),
      userProfileRepository: makeUserProfileRepository()
    )
  }
  
  func makeGetProfileDataUseCase() -> DefaultGetUserProfileUseCase {
    return DefaultGetUserProfileUseCase(
      userAPIRepository: makeUserAPIRepository(),
      userProfileRepository: makeUserProfileRepository()
    )
  }
  
  func makeGetAllInterestsUseCase() -> DefaultGetAllInterestsUseCase {
    return DefaultGetAllInterestsUseCase(
      userAPIRepository: makeUserAPIRepository(), 
      userProfileRepository: makeUserProfileRepository()
    )
  }
}
