//
//  UserProfile.swift
//  DomainUserInterface
//
//  Created by HUNHIE LEE on 2/3/24.
//

import Foundation

public struct UserProfile {
  public var nickname: String?
  public var mobileNumber: String
  public var birth: String?
  public var gender: Gender?
  public var mbti: String?
  public var authority: Authority
  public var address: String?
  public var imageUrl: String?
  public var interests: [Interest]
  public var job: String?
  public var introduce: String?
  public var school: String?
  public var blueCheck: Bool
  
  public init(nickname: String?, mobileNumber: String, birth: String? = nil, gender: Gender? = nil, mbti: String? = nil, authority: Authority, address: String? = nil, imageUrl: String? = nil, imageData: Data? = nil, interests: [Interest] = [], job: String? = nil, introduce: String? = nil, school: String? = nil, blueCheck: Bool) {
    self.nickname = nickname
    self.mobileNumber = mobileNumber
    self.birth = birth
    self.gender = gender
    self.mbti = mbti
    self.authority = authority
    self.address = address
    self.imageUrl = imageUrl
    self.interests = interests
    self.job = job
    self.introduce = introduce
    self.school = school
    self.blueCheck = blueCheck
  }
}

public enum Authority: String, Decodable {
  case anonymous = "ANONYMOUS"
  case user = "USER"
  case admin = "ADMIN"
}

public enum Gender: String, Decodable {
  case male = "MALE"
  case female = "FEMALE"
}
