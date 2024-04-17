//
//  LiveAPIRouter.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 2/3/24.
//

import Foundation
import Moya

public enum LiveAPIRouter: RouterProtocol, AccessTokenAuthorizable {
  case match(request: MatchRequestDTO)
}

public extension LiveAPIRouter {
  var baseURL: URL {
    return URL(string: Environment.baseURL + basePath)!
  }
  
  var basePath: String {
    return "/match"
  }
  
  var path: String {
    switch self {
    case .match:
      return ""
    }
  }
  var method: Moya.Method {
    switch self {
    case .match:
      return .post
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .match(let request):
      return .requestJSONEncodable(request)
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .match:
      return RequestHeader.getHeader([.json])
    }
  }
  
  var authorizationType: Moya.AuthorizationType? {
    switch self {
    case .match:
      return .bearer
    }
  }
}
