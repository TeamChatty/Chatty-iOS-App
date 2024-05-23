//
//  DefaultSaveProfileImageUseCase.swift
//  DomainUser
//
//  Created by 윤지호 on 5/14/24.
//

import Foundation
import RxSwift
import DomainUserInterface

public final class DefaultSaveProfileImageUseCase: SaveProfileImageUseCase {
  private let userAPIRepository: any UserAPIRepositoryProtocol
  private let userProfileRepository: any UserProfileRepositoryProtocol
  
  public init(userAPIRepository: any UserAPIRepositoryProtocol, userProfileRepository: any UserProfileRepositoryProtocol) {
    self.userAPIRepository = userAPIRepository
    self.userProfileRepository = userProfileRepository
  }
  
  public func execute(image: Data) -> Single<UserProfile> {
    return self.userAPIRepository.saveImage(imageData: image)
      .flatMap { userProfile in
        /// 최종적으로 저장된 데이터를 UserService에 저장해 둡니다.
        /// Single로 데이터를 전달받으니 weak self  사용시 self를 찾지 못했습니다.
        /// 추후 원인을 찾아보고 해결하겠습니다.
        self.userProfileRepository.saveUserProfile(userProfile: userProfile)
        return .just(userProfile)
      }
  }
}
