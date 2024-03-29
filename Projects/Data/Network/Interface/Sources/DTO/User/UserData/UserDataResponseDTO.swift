//
//  UserDataResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 1/25/24.
//

import Foundation
import DomainUserInterface
import DomainUser
import DomainUserInterface

public struct UserDataReponseDTO: Decodable {
  public let id: Int
  public let mobileNumber: String
  public let nickname: String
  public let birth: String?
  public let gender: Gender?
  public let mbti: String?
  public let authority: Authority
  public let address: String?
  public let interests: [String]
  public let imageUrl: String?
  public let school: String?
  public let job: String?
  public let introduce: String?
  public let blueCheck: Bool
  
  public func toDomain() -> UserProfile {
    return UserProfile(
      nickname: self.nickname,
      mobileNumber: self.mobileNumber,
      birth: self.birth,
      gender: self.gender,
      mbti: self.mbti,
      authority: self.authority,
      address: self.address,
      imageUrl: self.imageUrl,
      interests: self.interests.map { Interest(id: -1, name: $0) },
      job: self.job,
      introduce: self.introduce,
      school: self.school,
      blueCheck: self.blueCheck)
  }
}
