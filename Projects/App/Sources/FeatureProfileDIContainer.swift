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
      userDataRepository: makeUserDataRepository()
    )
  }
  
  func makeSaveProfileNicknameUseCase() -> DefaultSaveProfileNicknameUseCase {
    return DefaultSaveProfileNicknameUseCase(
      userAPIRepository: makeUserAPIRepository(),
      userDataRepository: makeUserDataRepository()
    )
  }
  
}
