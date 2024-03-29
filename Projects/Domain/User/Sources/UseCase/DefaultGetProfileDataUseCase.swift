//
//  DefaultGetProfileDataUseCase.swift
//  DomainUser
//
//  Created by 윤지호 on 2/19/24.
//

import Foundation
import DomainUserInterface
import RxSwift

public final class DefaultGetUserDataUseCase: GetUserDataUseCase {
  private let userAPIRepository: any UserAPIRepositoryProtocol
  private let userDataRepository: any UserDataRepositoryProtocol

  public init(userAPIRepository: any UserAPIRepositoryProtocol, userDataRepository: any UserDataRepositoryProtocol) {
    self.userAPIRepository = userAPIRepository
    self.userDataRepository = userDataRepository
  }
  
  public func executeSingle() -> Single<UserProfile> {
    return userAPIRepository.getProfile()
      .flatMap { userData in
        self.userDataRepository.saveUserData(userData: userData)
        return .just(self.userDataRepository.getUserData())
      }
  }
  
  public func execute() -> UserProfile {
    return userDataRepository.getUserData()
  }
}
