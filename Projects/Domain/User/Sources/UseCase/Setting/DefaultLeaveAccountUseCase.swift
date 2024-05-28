//
//  DefaultLeaveAccountUseCase.swift
//  DomainUser
//
//  Created by 윤지호 on 4/30/24.
//

import Foundation
import RxSwift

import DomainUserInterface
import DomainCommon

/// 로그아웃 로직만 있는 상태로, 추후 회원탈퇴 api 를 추가해야합니다.
public final class DefaultLeaveAccountUseCase: LeaveAccountUseCase {
  private let keychainRepository: any KeychainReposotoryProtocol
  private let userProfileRepository: any UserProfileRepositoryProtocol
  private let userAPIRepository: any UserAPIRepositoryProtocol
  
  public init(keychainRepository: any KeychainReposotoryProtocol, userProfileRepository: any UserProfileRepositoryProtocol, userAPIRepository: any UserAPIRepositoryProtocol) {
    self.keychainRepository = keychainRepository
    self.userProfileRepository = userProfileRepository
    self.userAPIRepository = userAPIRepository
  }
  
  public func execute() -> Observable<Void> {

    return userAPIRepository.leaveAccount()
      .flatMap { _ in
        return self.keychainRepository.requestDelete(type: .accessToken(""))
      }
      .flatMap { _ in
        return self.keychainRepository.requestDelete(type: .refreshToken(""))
      }
      .map { _ in
        self.userProfileRepository.resetProfile()
        return Void()
      }
      .asObservable()
  }
}
