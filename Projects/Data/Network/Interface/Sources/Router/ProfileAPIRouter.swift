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
  
  case notiReceive
  case notiChatting(agree: Bool)
  case notiFeed(agree: Bool)
  case notiMarketing(agree: Bool)
}

public extension ProfileAPIRouter {
  var baseURL: URL {
    return URL(string: Environment.baseURL + basePath)!
  }
  
  var basePath: String {
    switch self {
    case .profile, .profileUnlock:
      return "/api/v1/users/profile"
    case .notiReceive, .notiMarketing, .notiFeed, .notiChatting:
      return "v1/notification-receive"
    }
    
  }
  
  var path: String {
    switch self {
    case .profile(let userId):
      return "/\(userId)"
    case .profileUnlock(userId: let userId):
      return "/\(userId)"
      
    case .notiReceive:
      return ""
    case .notiChatting:
      return "/chatting"
    case .notiFeed:
      return "/feed"
    case .notiMarketing:
      return "/marketing"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .profile, .notiReceive:
      return .get
    case .profileUnlock(userId: let userId):
      return .post
    case .notiChatting, .notiFeed, .notiMarketing:
      return .put
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .profile(let userId):
      return .requestPlain
    case .profileUnlock(_, let method):
      let param = ["unlockMethod": "\(method.rawValue)"]
      return .requestParameters(parameters: param, encoding: JSONEncoding.default)
    case .notiReceive:
      return .requestPlain
    case .notiChatting(let agree):
      let param = ["agree": agree]
      return .requestParameters(parameters: param, encoding: JSONEncoding.default)
    case .notiFeed(let agree):
      let param = ["agree": agree]
      return .requestParameters(parameters: param, encoding: JSONEncoding.default)
    case .notiMarketing(let agree):
      let param = ["agree": agree]
      return .requestParameters(parameters: param, encoding: JSONEncoding.default)
    }
  }
  
  var headers: [String : String]? {
    switch self {
    default:
      return RequestHeader.getHeader([.json])
    }
  }
  
  var authorizationType: Moya.AuthorizationType? {
    switch self {
    default:
      return .bearer
    }
  }
}
