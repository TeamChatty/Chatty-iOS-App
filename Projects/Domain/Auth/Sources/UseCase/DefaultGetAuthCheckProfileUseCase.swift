//
//  DefaultGetAuthCheckProfileUseCase.swift
//  DomainAuth
//
//  Created by HUNHIE LEE on 2.05.2024.
//

import Foundation
import RxSwift
import DomainAuthInterface
import DomainUserInterface

public struct DefaultGetAuthCheckProfileUseCase {
  private let authAPIRepository: AuthAPIRepositoryProtocol
  private let userProfileRepository: UserProfileRepositoryProtocol
  
  public init(authAPIRepository: AuthAPIRepositoryProtocol, userProfileRepository: UserProfileRepositoryProtocol) {
    self.authAPIRepository = authAPIRepository
    self.userProfileRepository = userProfileRepository
  }
  
  public func execute() -> Single<String?> {
    let userProfile = userProfileRepository.getUserProfile()
    let mobileNumber = userProfile.mobileNumber
    return authAPIRepository.getAuthCheckProfileImageURL(mobileNumber: mobileNumber)
  }
}
