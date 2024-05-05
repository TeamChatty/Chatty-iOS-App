//
//  UserAPIRepositoryProtocol.swift
//  DomainUserInterface
//
//  Created by 윤지호 on 1/29/24.
//

import Foundation
import RxSwift
import DomainCommon

public protocol UserAPIRepositoryProtocol: AnyObject {
  func saveNickname(nickname: String) -> Single<UserProfile>
  func saveMBTI(mbti: String) -> Single<UserProfile>
  func saveImage(imageData: Data) -> Single<UserProfile>
  func saveGender(gender: String) -> Single<UserProfile>
  func saveBirth(birth: String) -> Single<UserProfile>
  func saveDeviceToken(deviceToken: String) -> Single<Void>

  func saveSchool(school: String) -> Single<UserProfile>
  func saveJob(job: String) -> Single<UserProfile>
  func saveIntroduce(introduce: String) -> Single<UserProfile>
  func saveInterests(interest: [Interest]) -> Single<UserProfile>
  func saveAddress(address: String) -> Single<UserProfile>
  
  func login(mobileNumber: String, authenticationNumber: String, deviceId: String, deviceToken: String) -> Single<TokenProtocol>
  func join(mobileNumber: String, authenticationNumber: String, deviceId: String, deviceToken: String) -> Single<TokenProtocol>
  
  func getProfile() -> Single<UserProfile>
  
  func getInterests() -> Single<Interests>
  
  func getNotiReceiveBoolean() -> Observable<NotificationReceiveCheck>
  func saveNotiChattingReceive(agree: Bool) -> Observable<Void>
  func saveNotiFeedReceive(agree: Bool) -> Observable<Void>
  func saveNotiMarketingReceive(agree: Bool) -> Observable<Void>
}
