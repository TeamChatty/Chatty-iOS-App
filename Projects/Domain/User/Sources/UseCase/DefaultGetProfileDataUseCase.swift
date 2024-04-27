//
//  DefaultGetProfileDataUseCase.swift
//  DomainUser
//
//  Created by 윤지호 on 2/19/24.
//

import Foundation
import DomainUserInterface
import DomainCommon
import RxSwift

public final class DefaultGetUserProfileUseCase: GetUserProfileUseCase {
  private let userAPIRepository: any UserAPIRepositoryProtocol
  private let userProfileRepository: any UserProfileRepositoryProtocol

  public init(userAPIRepository: any UserAPIRepositoryProtocol, userProfileRepository: any UserProfileRepositoryProtocol) {
    self.userAPIRepository = userAPIRepository
    self.userProfileRepository = userProfileRepository
  }
  
  public func executeSingle() -> Single<UserProfile> {
    return userAPIRepository.getProfile()
      .flatMap { userProfile in
        self.userProfileRepository.saveUserProfile(userProfile: userProfile)
        return .just(self.userProfileRepository.getUserProfile())
      }
  }
  
  public func execute() -> UserProfile {
    return userProfileRepository.getUserProfile()
  }
}
