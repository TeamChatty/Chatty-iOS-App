//
//  DefaultUserAPIRepository.swift
//  DataRepository
//
//  Created by 윤지호 on 1/25/24.
//

import Foundation
import RxSwift
import Moya
import DataNetworkInterface
import DataRepositoryInterface
import DomainUserInterface
import DomainCommon

public final class DefaultUserAPIRepository: UserAPIRepository {
  private let userAPIService: any UserAPIService
  private let profileAPIService: any ProfileAPIService
  private let interestAPIService: any InterestAPIService
  
  public init(userAPIService: any UserAPIService, profileAPIService: any ProfileAPIService, interestAPIService: any InterestAPIService) {
    self.userAPIService = userAPIService
    self.profileAPIService = profileAPIService
    self.interestAPIService = interestAPIService
  }
  
  // user
  public func saveNickname(nickname: String) -> Single<UserProfile> {
    let endPoint = UserAPIRouter.nickname(nickname: nickname)
    return userAPIService.request(endPoint: endPoint, responseDTO: SaveUserProfileResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  public func saveMBTI(mbti: String) -> Single<UserProfile> {
    let endPoint = UserAPIRouter.mbti(mbti: mbti)
    return userAPIService.request(endPoint: endPoint, responseDTO: SaveUserProfileResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  public func saveImage(imageData: Data) -> Single<UserProfile> {
    let endPoint = UserAPIRouter.image(imageData: imageData)
    return userAPIService.request(endPoint: endPoint, responseDTO: SaveUserProfileResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  public func saveGender(gender: String) -> Single<UserProfile> {
    let endPoint = UserAPIRouter.gender(gender: gender)
    return userAPIService.request(endPoint: endPoint, responseDTO: SaveUserProfileResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  public func saveBirth(birth: String) -> Single<UserProfile> {
    let endPoint = UserAPIRouter.birth(birth: birth)
    return userAPIService.request(endPoint: endPoint, responseDTO: SaveUserProfileResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  public func saveDeviceToken(deviceToken: String) -> Single<Void> {
    let endPoint = UserAPIRouter.deviceToken(deviceToken: deviceToken)
    return userAPIService.request(endPoint: endPoint, responseDTO: EmptyResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  
  public func saveSchool(school: String) -> Single<UserProfile> {
    let endPoint = UserAPIRouter.school(school: school)
    return userAPIService.request(endPoint: endPoint, responseDTO: SaveUserProfileResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  public func saveJob(job: String) -> Single<UserProfile> {
    let endPoint = UserAPIRouter.job(job: job)
    return userAPIService.request(endPoint: endPoint, responseDTO: SaveUserProfileResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  public func saveIntroduce(introduce: String) -> Single<UserProfile> {
    let endPoint = UserAPIRouter.introduce(introduce: introduce)
    return userAPIService.request(endPoint: endPoint, responseDTO: SaveUserProfileResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  public func saveInterests(interest: [Interest]) -> Single<UserProfile> {
    let interestIds = interest.map { $0.id }
    let endPoint = UserAPIRouter.interests(interests: interestIds)
    return userAPIService.request(endPoint: endPoint, responseDTO: SaveUserProfileResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  public func saveAddress(address: String) -> Single<UserProfile> {
    let endPoint = UserAPIRouter.address(address: address)
    return userAPIService.request(endPoint: endPoint, responseDTO: SaveUserProfileResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  public func getProfile() -> Single<UserProfile> {
    let endPoint = UserAPIRouter.profile
    return userAPIService.request(endPoint: endPoint, responseDTO: SaveUserProfileResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  
  public func login(mobileNumber: String, authenticationNumber: String, deviceId: String, deviceToken: String) -> Single<TokenProtocol> {
    let request = UserSignRequestDTO(
      mobileNumber: mobileNumber,
      authenticationNumber: authenticationNumber,
      deviceId: deviceId,
      deviceToken: deviceToken
    )
    let endPoint = UserAPIRouter.login(request: request)
    return userAPIService.request(endPoint: endPoint, responseDTO: UserSignResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  public func join(mobileNumber: String, authenticationNumber: String, deviceId: String, deviceToken: String) -> Single<TokenProtocol> {
    let request = UserSignRequestDTO(
      mobileNumber: mobileNumber,
      authenticationNumber: authenticationNumber,
      deviceId: deviceId,
      deviceToken: deviceToken
    )
    let endPoint = UserAPIRouter.join(request: request)
    return userAPIService.request(endPoint: endPoint, responseDTO: UserSignResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  
  // prodile
  public func myProfile() -> Single<UserProfile> {
    return userAPIService.request(endPoint: .profile, responseDTO: UserProfileReponseDTO.self)
      .map { $0.toDomain() }
  }
  
  public func someoneProfile(userId: Int) -> Single<SomeoneProfile> {
    return profileAPIService.request(endPoint: .profile(userId: userId), responseDTO: SomeoneProfileResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  // interest
  public func getInterests() -> Single<Interests> {
    return interestAPIService.request(endPoint: .interests, responseDTO: InterestsResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  public func getNotiReceiveBoolean() -> Observable<NotificationReceiveCheck> {
    return profileAPIService.request(endPoint: .notiReceive, responseDTO: NotificationReceiveResponseDTO.self)
      .asObservable()
      .map { $0.toDomain() }
  }
  
  public func saveNotiChattingReceive(agree: Bool) -> Observable<Void> {
    return profileAPIService.request(endPoint: .notiChatting(agree: agree), responseDTO: NotificationReceiveResponseDTO.self)
      .asObservable()
      .map { _ in Void() }
  }
  
  public func saveNotiFeedReceive(agree: Bool) -> Observable<Void> {
    return profileAPIService.request(endPoint: .notiFeed(agree: agree), responseDTO: NotificationReceiveResponseDTO.self)
      .asObservable()
      .map { _ in Void() }
  }
  
  public func saveNotiMarketingReceive(agree: Bool) -> Observable<Void> {
    return profileAPIService.request(endPoint: .notiMarketing(agree: agree), responseDTO: NotificationReceiveResponseDTO.self)
      .asObservable()
      .map { _ in Void() }
  }
  
  public func leaveAccount() -> Observable<Void> {
    return userAPIService.request(endPoint: .leaveAccount, responseDTO: SaveUserProfileResponseDTO.self)
      .asObservable()
      .map { _ in Void() }
  }
}
