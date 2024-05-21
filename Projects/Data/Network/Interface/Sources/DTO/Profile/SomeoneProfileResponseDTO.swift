//
//  SomeoneProfileResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 5/20/24.
//

import Foundation
import DomainUserInterface

public struct SomeoneProfileResponseDTO: CommonResponseDTO {
  public typealias Data = ResponseDTO
  public var code: Int
  public var status: String
  public var message: String
  public var data: Data
  
  public func toDomain() -> SomeoneProfile {
    let userProfile = UserProfile(
      userId: data.id,
      nickname: data.nickname,
      mobileNumber: "",
      birth: data.birth,
      gender: data.gender,
      mbti: data.mbti,
      authority: data.authority,
      address: data.address,
      imageUrl: data.imageUrl,
      interests: data.interests.map { Interest(id: $0.id, name: $0.name) },
      job: data.job,
      introduce: data.introduce,
      school: data.school,
      blueCheck: data.blueCheck)
    return SomeoneProfile(
      profile: userProfile,
      unlock: data.unlock
    )
  }
  
  public struct ResponseDTO: Decodable {
    public let id: Int
    public let nickname: String?
    public let birth: String?
    public let gender: Gender?
    public let mbti: String?
    public let authority: Authority
    public let address: String?
    public let interests: [InterestsDTO]
    public let imageUrl: String?
    public let school: String?
    public let job: String?
    public let introduce: String?
    public let blueCheck: Bool
    public let unlock: Bool
    
    public func toDomain() -> SomeoneProfile {
      return SomeoneProfile(
        profile: UserProfile(
          userId: self.id,
          nickname: self.nickname,
          mobileNumber: "",
          birth: self.birth,
          gender: self.gender,
          mbti: self.mbti,
          authority: self.authority,
          address: self.address,
          imageUrl: self.imageUrl,
          interests: self.interests.map { Interest(id: $0.id, name: $0.name) },
          job: self.job,
          introduce: self.introduce,
          school: self.school,
          blueCheck: self.blueCheck),
        unlock: self.unlock)
      
    }
  }

}
