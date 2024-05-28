//
//  UserRouter.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 1/15/24.
//

import Foundation
import Moya

public enum UserAPIRouter: RouterProtocol, AccessTokenAuthorizable {
  case nickname(nickname: String)
  case mbti(mbti: String)
  case image(imageData: Data)
  case gender(gender: String)
  case deviceToken(deviceToken: String)
  case birth(birth: String)
  
  case school(school: String)
  case job(job: String)
  case introduce(introduce: String)
  case interests(interests: [Int])
  case address(address: String)
  
  case login(request: UserSignRequestDTO)
  case join(request: UserSignRequestDTO)
  
  case profile
  
  ///  계정삭제
  case leaveAccount
}

public extension UserAPIRouter  {
  var baseURL: URL {
    return URL(string: Environment.baseURL + basePath)!
  }
  
  var basePath: String {
    return "/users"
  }
  
  var path: String {
    switch self {
    case .nickname:
      return "/nickname"
    case .mbti:
      return "/mbti"
    case .image:
      return "/image"
    case .gender:
      return "/gender"
    case .deviceToken:
      return "/deviceToken"
    case .birth:
      return "/birth"
      
    case .school:
      return "/school"
    case .job:
      return "/job"
    case .introduce:
      return "/introduce"
    case .interests:
      return "/interests"
    case .address:
      return "/address"
      
    case .login:
      return "/login"
    case .join:
      return "/join"
    
    case .profile:
      return "/my/profile"
      
    case .leaveAccount:
      return "/cancel-membership"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .nickname, .mbti, .image, .gender, .deviceToken, .birth, .school, .job, .introduce, .interests, .address:
      return .put
    case .login, .join:
      return .post
    case .profile:
      return .get
    case .leaveAccount:
      return .delete
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .nickname(let nickname):
      let param = ["nickname": nickname]
      return .requestParameters(parameters: param, encoding: JSONEncoding.default)
    case .mbti(let mbti):
      let param = ["mbti": mbti]
      return .requestParameters(parameters: param, encoding: JSONEncoding.default)
    case .image(let image):
      let imagemutipartFormData = MultipartFormData(provider: .data(image), name: "image", fileName: "user_avatar.jpeg", mimeType: "image/jpeg")
      return .uploadMultipart([imagemutipartFormData])
    case .gender(let gender):
      let param = ["gender": gender]
      return .requestParameters(parameters: param, encoding: JSONEncoding.default)
    case .deviceToken(let deviceToken):
      let param = ["deviceToken": deviceToken]
      return .requestParameters(parameters: param, encoding: JSONEncoding.default)
    case .birth(let birth):
      let param = ["birth": birth]
      return .requestParameters(parameters: param, encoding: JSONEncoding.default)
    
    case .school(let school):
      let param = ["school": school]
      return .requestParameters(parameters: param, encoding: JSONEncoding.default)
    case .job(job: let job):
      let param = ["job": job]
      return .requestParameters(parameters: param, encoding: JSONEncoding.default)
    case .introduce(let introduce):
      let param = ["introduce": introduce]
      return .requestParameters(parameters: param, encoding: JSONEncoding.default)
    case .interests(let interests):
      let param = ["interests": interests]
      return .requestParameters(parameters: param, encoding: JSONEncoding.default)
    case .address(let address):
      let param = ["address": address]
      return .requestParameters(parameters: param, encoding: JSONEncoding.default)
      
    case .login(let request):
      return .requestJSONEncodable(request)
    case .join(let request):
      return .requestJSONEncodable(request)
      
    case .profile:
      return .requestPlain
      
    case .leaveAccount:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .nickname, .mbti, .gender, .deviceToken, .birth, .school, .job, .introduce, .interests, .address:
      return RequestHeader.getHeader([.json])
    case .image:
      return RequestHeader.getHeader([.binary])
    case .login, .join:
      return RequestHeader.getHeader([.json])
    case .profile:
      return .none
    case .leaveAccount:
      return .none
    }
  }
  
  var authorizationType: Moya.AuthorizationType? {
    switch self {
    case .nickname, .mbti, .image, .gender, .deviceToken, .birth, .school, .job, .introduce, .interests, .address, .profile, .leaveAccount:
      return .bearer
    default:
      return .none
    }
  }
}
