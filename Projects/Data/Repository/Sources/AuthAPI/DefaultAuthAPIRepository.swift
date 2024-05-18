//
//  DefaultAuthAPIRepository.swift
//  DataRepository
//
//  Created by HUNHIE LEE on 1/27/24.
//

import Foundation
import DataNetworkInterface
import DataRepositoryInterface
import RxSwift
import Moya
import DomainCommon
import DomainAuthInterface

public struct DefaultAuthAPIRepository: AuthAPIRepository {
  public func getAuthCheckProfileImageURL(mobileNumber: String) -> Single<String?> {
    return authAPIService.request(endPoint: .profile(mobileNumber: mobileNumber), responseDTO: ProfileResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  private let authAPIService: any AuthAPIService
  
  public init(authAPIService: any AuthAPIService) {
    self.authAPIService = authAPIService
  }
  
  public func tokenRefresh(refreshToken: String) -> Single<TokenProtocol> {
    let request = RefreshRequestDTO(refreshToken: refreshToken)
    return authAPIService.request(endPoint: .refresh(request), responseDTO: RefreshResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  public func sendVerificationCode(mobileNumber: String, deviceId: String) -> Single<Int> {
    let request = MobileRequestDTO(mobileNumber: mobileNumber, deviceId: deviceId)
    return authAPIService.request(endPoint: .mobile(request), responseDTO: MobileResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  public func tokenValidation() -> Single<Bool> {
    return authAPIService.request(endPoint: .token, responseDTO: EmptyResponseDTO.self)
      .map { _ in true }
  }
  
  public func getAuthCheckQuestion(forNickname mobileNumber: String) -> Single<[String]> {
    return authAPIService.request(endPoint: .problem(.init(checkType: .nickname, body: .init(mobileNumber: mobileNumber))), responseDTO: QuestionResponseDTO.self).map {
      $0.toDomain()
    }
  }
  
  public func getAuthCheckQuestion(forBirth mobileNumber: String) -> Single<[String]> {
    return authAPIService.request(endPoint: .problem(.init(checkType: .birth, body: .init(mobileNumber: mobileNumber))), responseDTO: QuestionResponseDTO.self).map {
      $0.toDomain()
    }
  }
  
  public func submitAuthCheckAnswer(type: AuthCheckType, answer: String, mobileNumber: String) -> Single<Bool> {
    return authAPIService.request(endPoint: .check(.init(checkType: type, body: CheckRequestDTO.CheckRequestBody(mobileNumber: mobileNumber, answer: answer))), responseDTO: CheckResponseDTO.self)
      .map { $0.toDomain() } 
  }
}
