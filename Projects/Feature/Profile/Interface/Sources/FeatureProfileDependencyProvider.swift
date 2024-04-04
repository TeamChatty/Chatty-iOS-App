// This is for Tuist

import DomainUser

public protocol FeatureProfileDependencyProvider {
  func makeGetProfileDataUseCase() -> DefaultGetUserDataUseCase
  func makeSaveProfileNicknameUseCase() -> DefaultSaveProfileNicknameUseCase
  func makeSaveAddressUseCase() -> DefaultSaveAddressUseCase
  func makeSaveJobUseCase() -> DefaultSaveJobUseCase
  func makeSaveSchoolUseCase() -> DefaultSaveSchoolUseCase
  func makeSaveIntroduceUseCase() -> DefaultSaveIntroduceUseCase
  func makeSaveMBTIUseCase() -> DefaultSaveMBTIUseCase
  func makeSaveInterestsUseCase() -> DefaultSaveInterestsUseCase
}
