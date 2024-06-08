//
//  CustomMoyaPlugin.swift
//  DataNetwork
//
//  Created by 윤지호 on 2/14/24.
//

import Foundation
import DataStorageInterface

import Moya
import RxSwift

public final class MoyaPlugin: PluginType {
  private let keychainService: KeychainServiceProtocol
  
  public init(keychainService: KeychainServiceProtocol) {
    self.keychainService = keychainService
  }

  /// KeychainService에서 RefreshToken을 가져온 후 Header에 포함시키는 역할을 합니다.
  public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    guard let authorizable = target as? AccessTokenAuthorizable,
          let authorizationType = authorizable.authorizationType,
          let accessToken: String = keychainService.read(type: .accessToken())
    else { return request }
    
    var request = request
    let authValue = authorizationType.value + " " + accessToken
    request.addValue(authValue, forHTTPHeaderField: "Authorization")
    print("지금 사용하는 토큰: \(accessToken)")
    return request
  }
}

extension MoyaPlugin {
  /// Request를 보낼 때 호출
  public func willSend(_ request: RequestType, target: TargetType) {
    guard let httpRequest = request.request else {
//      print("--> 유효하지 않은 요청")
      return
    }
    let url = httpRequest.description
    let method = httpRequest.httpMethod ?? "unknown method"
//    var log = "----------------------------------------------------\n\n[\(method)] \(url)\n\n----------------------------------------------------\n"
//    log.append("API: \(target)\n")
    if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
//      log.append("header: \(headers)\n")
    }
    if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
//      log.append("\(bodyString)\n")
    }
//    log.append("------------------- END \(method) --------------------------")
//    print(log)
  }
  
  /// Response 받았을 시 분기 처리
  public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
    switch result {
    case let .success(response):
      onSuceed(response, target: target, isFromError: false)
    case let .failure(error):
      onFail(error, target: target)
    }
  }
    
  /// 네트워크 통신 성공 시
  func onSuceed(_ response: Response, target: TargetType, isFromError: Bool) {
    let request = response.request
    let url = request?.url?.absoluteString ?? "nil"
    let statusCode = response.statusCode
    var log = "------------------- onSuceed: 네트워크 통신 성공 -------------------"
    log.append("\n[\(statusCode)] \(url)\n----------------------------------------------------\n")
    log.append("API: \(target)\n")
    response.response?.allHeaderFields.forEach {
      log.append("\($0): \($1)\n")
    }
    if let reString = String(bytes: response.data, encoding: String.Encoding.utf8) {
      log.append("\(reString)\n")
    }
    log.append("------------- onSuceed: END HTTP (\(response.data.count)-byte body) -------------")
    print(log)
  }
    
  /// 네트워크 통신 실패 시
  func onFail(_ error: MoyaError, target: TargetType) {
    if let response = error.response {
      onSuceed(response, target: target, isFromError: true)
      return
    }
    var log = "------------------- onFail: 네트워크 오류 -------------------"
    log.append("url <-- \(target.baseURL)\n")
    log.append("<-- \(error.errorCode) \(target)\n")
    log.append("\(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
    log.append("<-- END HTTP")
    print(log)
  }
}

