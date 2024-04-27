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
  private let userDataRepository: any UserProfileRepositoryProtocol
  
  public init(userAPIRepository: any UserAPIRepositoryProtocol, userDataRepository: any UserProfileRepositoryProtocol) {
    self.userAPIRepository = userAPIRepository
    self.userDataRepository = userDataRepository
  }
  
  public func execute() -> Single<Interests> {
    return userAPIRepository.getInterests()
      .map { interests in
        self.userDataRepository.saveAllInterests(interests: interests)
        return interests
      }
  }
}
