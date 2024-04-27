//
//  SaveNicknameUsecase.swift
//  DomainAuthInterface
//
//  Created by 윤지호 on 1/25/24.
//

import Foundation
import DomainUserInterface
import RxSwift

public final class DefaultSaveProfileNicknameUseCase: SaveProfileNicknameUseCase {
  private let userAPIRepository: any UserAPIRepositoryProtocol
  private let userDataRepository: any UserProfileRepositoryProtocol
  
  public init(userAPIRepository: any UserAPIRepositoryProtocol, userDataRepository: any UserProfileRepositoryProtocol) {
    self.userAPIRepository = userAPIRepository
    self.userDataRepository = userDataRepository
  }
  
  public func excute(nickname: String) -> Single<Bool> {
    return userAPIRepository.saveNickname(nickname: nickname)
      .flatMap { userData -> Single<Bool> in
        /// 최종적으로 저장된 데이터를 UserService에 저장해 둡니다.
        /// Single로 데이터를 전달받으니 weak self  사용시 self를 찾지 못했습니다.
        /// 추후 원인을 찾아보고 해결하겠습니다.
        self.userDataRepository.saveUserProfile(userProfile: userData)
        return .just(true)
      }
  }
}
