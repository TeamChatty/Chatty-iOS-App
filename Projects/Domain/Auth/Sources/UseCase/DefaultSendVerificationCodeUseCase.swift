//
//  DefaultSendVerificationCodeUseCase.swift
//  DomainAuth
//
//  Created by HUNHIE LEE on 2/2/24.
//

import Foundation
import DomainAuthInterface
import DomainCommon
import DomainUserInterface
import RxSwift

public struct DefaultSendVerificationCodeUseCase: SendVerificationCodeUseCase {
  private let authAPIRepository: AuthAPIRepositoryProtocol
  private let keychainRepository: KeychainReposotoryProtocol
  private let userProfileRepository: UserProfileRepositoryProtocol
  
  public init(authAPIRepository: AuthAPIRepositoryProtocol, keychainRepository: KeychainReposotoryProtocol, userProfileRepository: UserProfileRepositoryProtocol) {
    self.authAPIRepository = authAPIRepository
    self.keychainRepository = keychainRepository
    self.userProfileRepository = userProfileRepository
  }
  
  public func execute(mobileNumber: String) -> Single<Void> {
    let userProfile = UserProfile(userId: 0, nickname: nil, mobileNumber: mobileNumber, authority: .anonymous, blueCheck: false)
    userProfileRepository.saveUserProfile(userProfile: userProfile)
    return keychainRepository.requestRead(type: .deviceId())
      .flatMap { deviceId in
        return authAPIRepository.sendVerificationCode(mobileNumber: mobileNumber, deviceId: deviceId)
      }
  }
}
