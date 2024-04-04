// This is for Tuist

import DomainUser

public protocol FeatureProfileDependencyProvider {
  func makeGetProfileDataUseCase() -> DefaultGetUserDataUseCase
  func makeSaveProfileNicknameUseCase() -> DefaultSaveProfileNicknameUseCase
}
