//
//  DefaultSaveProfileDataUseCase.swift
//  DomainUser
//
//  Created by 윤지호 on 2/19/24.
//

import Foundation
import DomainUserInterface
import DomainCommon
import RxSwift

public final class DefaultSaveProfileDataUseCase: SaveProfileDataUseCase {

  
  private let userAPIRepository: any UserAPIRepositoryProtocol
  private let userProfileRepository: any UserProfileRepositoryProtocol
  
  public init(userAPIRepository: any UserAPIRepositoryProtocol, userProfileRepository: any UserProfileRepositoryProtocol) {
    self.userAPIRepository = userAPIRepository
    self.userProfileRepository = userProfileRepository
  }
  
  public func executeObs(gender: String, birth: String, imageData: Data?, interests: [Interest], mbti: String) -> Observable<UserProfile> {
    
    let saveGender = userAPIRepository.saveGender(gender: gender).asObservable()
    let saveBirth = userAPIRepository.saveBirth(birth: birth).asObservable()
    let saveInterests = userAPIRepository.saveInterests(interest: interests).asObservable()
    let saveMbti = userAPIRepository.saveMBTI(mbti: mbti).asObservable()
    
    if let imageData = imageData {
      let saveImage = userAPIRepository.saveImage(imageData: imageData).asObservable()
      return saveGender
        .flatMap { _ -> Observable<UserProfile> in
          return saveBirth
        }
        .flatMap { _ -> Observable<UserProfile> in
          return saveBirth
        }
        .flatMap { _ -> Observable<UserProfile> in
          return saveInterests
        }
        .flatMap { _ -> Observable<UserProfile> in
          return saveImage
        }
        .flatMap { _ -> Observable<UserProfile> in
          return saveMbti.map { userProfile in
            /// 최종적으로 저장된 데이터를 UserService에 저장해 둡니다.
            self.userProfileRepository.saveUserProfile(userProfile: userProfile)
            return userProfile
          }
        }
    } else {
      return saveGender
        .flatMap { _ -> Observable<UserProfile> in
          return saveBirth
        }
        .flatMap { _ -> Observable<UserProfile> in
          return saveBirth
        }
        .flatMap { _ -> Observable<UserProfile> in
          return saveInterests
        }
        .flatMap { _ -> Observable<UserProfile> in
          return saveMbti.map { userProfile in
            /// 최종적으로 저장된 데이터를 UserService에 저장해 둡니다.
            self.userProfileRepository.saveUserProfile(userProfile: userProfile)
            return userProfile
          }
        }
    }
  }
}
