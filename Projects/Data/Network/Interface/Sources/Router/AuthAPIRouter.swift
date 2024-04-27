//
//  AuthAPIRouter.swift
//  DataNetworkInterface
//
//  Created by walkerhilla on 1/15/24.
//

import Foundation
import Moya

public enum AuthAPIRouter: RouterProtocol, AccessTokenAuthorizable {
  case mobile(MobileRequestDTO)
  case refresh(RefreshRequestDTO)
  case token
  case problem(QuestionRequestDTO)
  case check(CheckRequestDTO)
}

public extension AuthAPIRouter {
  var baseURL: URL {
    return URL(string: Environment.baseURL + basePath)!
  }
  
  var basePath: String {
    switch self {
    case .mobile, .refresh, .token:
      return "/auth"
    case .problem, .check:
      return "/check"
    }
  }
  
  var path: String {
    switch self {
    case .mobile:
      return "/mobile"
    case .refresh:
      return "/refresh"
    case .token:
      return "/token"
    case .problem(let dto):
      switch dto.checkType {
      case .birth:
        return "/problem/birth"
      case .nickname:
        return "/problem/nickname"
      }
    case .check(let dto):
      switch dto.checkType {
      case .birth:
        return "/nickname"
      case .nickname:
        return "/birth"
      }
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .mobile, .refresh, .token:
      return .post
    case .problem:
      return .get
    case .check:
      return .post
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .mobile(let mobileRequestDTO):
      return .requestJSONEncodable(mobileRequestDTO)
    case .refresh(let refreshRequestDTO):
      return .requestJSONEncodable(refreshRequestDTO)
    case .token:
      return .requestPlain
    case .problem(let problemRequestDTO):
      return .requestJSONEncodable(problemRequestDTO.body)
    case .check(let checkRequestDTO):
      return .requestJSONEncodable(checkRequestDTO.body)
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .mobile, .refresh, .token, .problem, .check:
      return ["Content-Type": "application/json"]
    }
  }
  
  var authorizationType: AuthorizationType? {
    switch self {
    case .token:
      return .bearer
    default:
      return .none
    }
  }
}


