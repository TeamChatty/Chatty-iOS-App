//
//  ProfileAPIRouter.swift
//  DataNetworkInterface
//
//  Created by HUNHIE LEE on 2/26/24.
//

import Foundation
import Moya

public enum MethodType: String {
  case candy
  case ticket
}

public enum ProfileAPIRouter: RouterProtocol, AccessTokenAuthorizable {
  case profile(userId: Int)
  case profileUnlock(userId: Int, methodType: MethodType)
}

public extension ProfileAPIRouter {
  var baseURL: URL {
    return URL(string: Environment.baseURL + basePath)!
  }
  
  var basePath: String {
    return "/v1/users/profile"
  }
  
  var path: String {
    switch self {
    case .profile(let userId):
      return "/\(userId)"
    case .profileUnlock(userId: let userId):
      return "/\(userId)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .profile(let userId):
      return .get
    case .profileUnlock(userId: let userId):
      return .post
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .profile(let userId):
      return .requestPlain
    case .profileUnlock(_, let method):
      let param = ["unlockMethod": "\(method.rawValue)"]
      return .requestParameters(parameters: param, encoding: JSONEncoding.default)
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .profile, .profileUnlock:
      return RequestHeader.getHeader([.json])
    }
  }
  
  var authorizationType: Moya.AuthorizationType? {
    switch self {
    case .profile, .profileUnlock:
      return .bearer
    }
  }
}
