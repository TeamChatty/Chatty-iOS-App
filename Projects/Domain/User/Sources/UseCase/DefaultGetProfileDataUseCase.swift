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

public final class DefaultGetUserDataUseCase: GetUserDataUseCase {
  private let userAPIRepository: any UserAPIRepositoryProtocol
  private let userDataRepository: any UserProfileRepositoryProtocol

  public init(userAPIRepository: any UserAPIRepositoryProtocol, userDataRepository: any UserProfileRepositoryProtocol) {
    self.userAPIRepository = userAPIRepository
    self.userDataRepository = userDataRepository
  }
  
  public func executeSingle() -> Single<UserProfile> {
    return userAPIRepository.getProfile()
      .flatMap { userData in
        self.userDataRepository.saveUserProfile(userProfile: userData)
        return .just(self.userDataRepository.getUserProfile())
      }
  }
  
  public func execute() -> UserProfile {
    return userDataRepository.getUserProfile()
  }
}
