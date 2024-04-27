//
//  AuthAPIRepositoryProtocol.swift
//  DomainAuthInterface
//
//  Created by 윤지호 on 1/29/24.
//

import Foundation
import RxSwift
import DomainCommon

public protocol AuthAPIRepositoryProtocol {
  func tokenRefresh(refreshToken: String) -> Single<TokenProtocol>
  func sendVerificationCode(mobileNumber: String, deviceId: String) -> Single<Void>
  func tokenValidation() -> Single<Bool>
  func getAuthCheckQuestion(forNickname mobileNumber: String) -> Single<[String]>
  func getAuthCheckQuestion(forBirth mobileNumber: String) -> Single<[String]>
}
