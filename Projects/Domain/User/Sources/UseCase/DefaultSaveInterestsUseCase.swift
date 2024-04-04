//
//  DefaultSaveInterestsUseCase.swift
//  DomainUser
//
//  Created by 윤지호 on 4/5/24.
//

import Foundation
import RxSwift
import DomainUserInterface

public final class DefaultSaveInterestsUseCase: SaveInterestsUseCase {
  private let userAPIRepository: any UserAPIRepositoryProtocol
  private let userDataRepository: any UserDataRepositoryProtocol
  
  public init(userAPIRepository: any UserAPIRepositoryProtocol, userDataRepository: any UserDataRepositoryProtocol) {
    self.userAPIRepository = userAPIRepository
    self.userDataRepository = userDataRepository
  }
  
  public func execute(interests: [Interest]) -> Single<Bool> {
    return userAPIRepository.saveInterests(interest: interests)
      .flatMap { userData -> Single<Bool> in
        /// 최종적으로 저장된 데이터를 UserService에 저장해 둡니다.
        /// Single로 데이터를 전달받으니 weak self  사용시 self를 찾지 못했습니다.
        /// 추후 원인을 찾아보고 해결하겠습니다.
        self.userDataRepository.saveUserData(userData: userData)
        return .just(true)
      }
  }
}
