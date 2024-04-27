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
  
  func makeGetProfileDataUseCase() -> DefaultGetUserDataUseCase {
    return DefaultGetUserDataUseCase(
      userAPIRepository: makeUserAPIRepository(),
      userDataRepository: makeUserProfileRepository()
    )
  }
  
  func makeSaveProfileNicknameUseCase() -> DefaultSaveProfileNicknameUseCase {
    return DefaultSaveProfileNicknameUseCase(
      userAPIRepository: makeUserAPIRepository(),
      userDataRepository: makeUserDataRepository()
    )
  }
  
  func makeSaveAddressUseCase() -> DefaultSaveAddressUseCase {
    return DefaultSaveAddressUseCase(
      userAPIRepository: makeUserAPIRepository(),
      userDataRepository: makeUserDataRepository()
    )
  }
  
  func makeSaveJobUseCase() -> DefaultSaveJobUseCase {
    return DefaultSaveJobUseCase(
      userAPIRepository: makeUserAPIRepository(),
      userDataRepository: makeUserDataRepository()
    )
  }
  
  func makeSaveSchoolUseCase() -> DefaultSaveSchoolUseCase {
    return DefaultSaveSchoolUseCase(
      userAPIRepository: makeUserAPIRepository(),
      userDataRepository: makeUserDataRepository()
    )
  }
  
  func makeSaveIntroduceUseCase() -> DefaultSaveIntroduceUseCase {
    return DefaultSaveIntroduceUseCase(
      userAPIRepository: makeUserAPIRepository(),
      userDataRepository: makeUserDataRepository()
    )
  }
  
  func makeSaveMBTIUseCase() -> DefaultSaveMBTIUseCase {
    return DefaultSaveMBTIUseCase(
      userAPIRepository: makeUserAPIRepository(),
      userDataRepository: makeUserDataRepository()
    )
  }
  
  func makeSaveInterestsUseCase() -> DefaultSaveInterestsUseCase {
    return DefaultSaveInterestsUseCase(
      userAPIRepository: makeUserAPIRepository(),
      userDataRepository: makeUserDataRepository()
    )
  }
  
  func makeGetAllInterestsUseCase() -> DefaultGetAllInterestsUseCase {
    return DefaultGetAllInterestsUseCase(
      userAPIRepository: makeUserAPIRepository(),
      userDataRepository: makeUserDataRepository()
    )
  }
}
