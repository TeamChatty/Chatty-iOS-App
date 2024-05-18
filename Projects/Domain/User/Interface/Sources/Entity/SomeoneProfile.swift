//
//  SomeoneProfile.swift
//  DomainUserInterface
//
//  Created by HUNHIE LEE on 2/26/24.
//

import Foundation

public struct SomeoneProfile {
  public let userId: Int
  public var nickname: String
  public var birth: String
  public var gender: Gender
  public var mbti: String
  public var address: String?
  public var imageUrl: String?
  public var interests: [Interest]
  public var job: String?
  public var introduce: String?
  public var school: String?
  
  public var blueCheck: Bool
  public var authority: Authority
  public let unlock: Bool
  
  public init(userId: Int, nickname: String, birth: String, gender: Gender, mbti: String, address: String? = nil, imageUrl: String? = nil, interests: [Interest], job: String? = nil, introduce: String? = nil, school: String? = nil, blueCheck: Bool, authority: Authority, unlock: Bool) {
    self.userId = userId
    self.nickname = nickname
    self.birth = birth
    self.gender = gender
    self.mbti = mbti
    self.address = address
    self.imageUrl = imageUrl
    self.interests = interests
    self.job = job
    self.introduce = introduce
    self.school = school
    self.blueCheck = blueCheck
    self.authority = authority
    self.unlock = unlock
  }
}
