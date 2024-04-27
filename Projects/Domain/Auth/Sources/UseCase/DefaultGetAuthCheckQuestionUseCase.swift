//
//  DefaultGetAuthCheckProblemUseCase.swift
//  DomainAuth
//
//  Created by HUNHIE LEE on 23.04.2024.
//

import Foundation
import RxSwift
import DomainAuthInterface
import DomainUserInterface

public struct DefaultGetAuthCheckQuestionUseCase {
  private let authAPIRepository: AuthAPIRepositoryProtocol
  private let userProfileRepository: UserProfileRepositoryProtocol
  
  public init(authAPIRepository: AuthAPIRepositoryProtocol, userProfileRepository: UserProfileRepositoryProtocol) {
    self.authAPIRepository = authAPIRepository
    self.userProfileRepository = userProfileRepository
  }
  
  public func executeForNickname() -> Single<[String]> {
    let userProfile = userProfileRepository.getUserProfile()
    let mobileNumber = userProfile.mobileNumber
    return authAPIRepository.getAuthCheckQuestion(forNickname: mobileNumber)
  }
  
  public func executeForBirth() -> Single<[String]> {
    let userProfile = userProfileRepository.getUserProfile()
    let mobileNumber = userProfile.mobileNumber
    return authAPIRepository.getAuthCheckQuestion(forBirth: mobileNumber)
  }
}
