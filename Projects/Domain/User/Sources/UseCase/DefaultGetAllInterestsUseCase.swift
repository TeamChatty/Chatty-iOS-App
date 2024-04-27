//
//  DefaultGetInterestsUserCase.swift
//  DomainUserInterface
//
//  Created by 윤지호 on 3/7/24.
//

import Foundation
import DomainUserInterface
import DomainCommon
import RxSwift

public final class DefaultGetAllInterestsUseCase: GetAllInterestsUseCase {
  private let userAPIRepository: any UserAPIRepositoryProtocol
  private let userProfileRepository: any UserProfileRepositoryProtocol
  
  public init(userAPIRepository: any UserAPIRepositoryProtocol, userProfileRepository: any UserProfileRepositoryProtocol) {
    self.userAPIRepository = userAPIRepository
    self.userProfileRepository = userProfileRepository
  }
  
  public func execute() -> Single<Interests> {
    return userAPIRepository.getInterests()
      .map { interests in
        self.userProfileRepository.saveAllInterests(interests: interests)
        return interests
      }
  }
}
