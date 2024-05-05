//
//  FeatureProfileDIContainer.swift
//  Chatty
//
//  Created by 윤지호 on 3/17/24.
//

import Foundation
import FeatureProfileInterface

import DomainUser

final class FeatureProfileDIContainer: RepositoryDIcontainer, FeatureProfileDependencyProvider {
  
  func makeGetProfileDataUseCase() -> DefaultGetUserProfileUseCase {
    return DefaultGetUserProfileUseCase(
      userAPIRepository: makeUserAPIRepository(),
      userProfileRepository: makeUserProfileRepository()
    )
  }
  
  func makeSaveProfileNicknameUseCase() -> DefaultSaveProfileNicknameUseCase {
    return DefaultSaveProfileNicknameUseCase(
      userAPIRepository: makeUserAPIRepository(),
      userProfileRepository: makeUserProfileRepository()
    )
  }
  
  func makeSaveAddressUseCase() -> DefaultSaveAddressUseCase {
    return DefaultSaveAddressUseCase(
      userAPIRepository: makeUserAPIRepository(),
      userProfileRepository: makeUserProfileRepository()
    )
  }
  
  func makeSaveJobUseCase() -> DefaultSaveJobUseCase {
    return DefaultSaveJobUseCase(
      userAPIRepository: makeUserAPIRepository(),
      userProfileRepository: makeUserProfileRepository()
    )
  }
  
  func makeSaveSchoolUseCase() -> DefaultSaveSchoolUseCase {
    return DefaultSaveSchoolUseCase(
      userAPIRepository: makeUserAPIRepository(),
      userProfileRepository: makeUserProfileRepository()
    )
  }
  
  func makeSaveIntroduceUseCase() -> DefaultSaveIntroduceUseCase {
    return DefaultSaveIntroduceUseCase(
      userAPIRepository: makeUserAPIRepository(),
      userProfileRepository: makeUserProfileRepository()
    )
  }
  
  func makeSaveMBTIUseCase() -> DefaultSaveMBTIUseCase {
    return DefaultSaveMBTIUseCase(
      userAPIRepository: makeUserAPIRepository(),
      userProfileRepository: makeUserProfileRepository()
    )
  }
  
  func makeSaveInterestsUseCase() -> DefaultSaveInterestsUseCase {
    return DefaultSaveInterestsUseCase(
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
  
  func makeGetNotificationCheckedData() -> DefaultGetNotificationCheckedData {
    return DefaultGetNotificationCheckedData(
      userAPIRepository: makeUserAPIRepository()
    )
  }
  
  func makeSaveNotificationBoolean() -> DefaultSaveNotificationBoolean {
    return DefaultSaveNotificationBoolean(
      userAPIRepository: makeUserAPIRepository()
    )
  }
  
  func makeLogoutUseCase() -> DefaultLogoutUseCase {
    return DefaultLogoutUseCase(
      keychainRepository: makeKeychainRepository(),
      userProfileRepository: makeUserProfileRepository())
  }
  
  func makeLeaveAccountUseCase() -> DefaultLeaveAccountUseCase {
    return DefaultLeaveAccountUseCase(
      keychainRepository: makeKeychainRepository(),
      userProfileRepository: makeUserProfileRepository())
  }
}
