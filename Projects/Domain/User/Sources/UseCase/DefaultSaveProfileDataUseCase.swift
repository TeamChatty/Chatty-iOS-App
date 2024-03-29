//
//  DefaultSaveProfileDataUseCase.swift
//  DomainUser
//
//  Created by 윤지호 on 2/19/24.
//

import Foundation
import DomainUserInterface
import RxSwift

public final class DefaultSaveProfileDataUseCase: SaveProfileDataUseCase {

  
  private let userAPIRepository: any UserAPIRepositoryProtocol
  private let userDataRepository: any UserDataRepositoryProtocol
  
  public init(userAPIRepository: any UserAPIRepositoryProtocol, userDataRepository: any UserDataRepositoryProtocol) {
    self.userAPIRepository = userAPIRepository
    self.userDataRepository = userDataRepository
  }
  
  public func executeObs(gender: String, birth: String, imageData: Data?, interests: [DomainUserInterface.Interest], mbti: String) -> Observable<UserProfile> {
    
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
          return saveMbti.map { userData in
            /// 최종적으로 저장된 데이터를 UserService에 저장해 둡니다.
            self.userDataRepository.saveUserData(userData: userData)
            return userData
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
          return saveMbti.map { userData in
            /// 최종적으로 저장된 데이터를 UserService에 저장해 둡니다.
            self.userDataRepository.saveUserData(userData: userData)
            return userData
          }
        }
    }
  }
}
