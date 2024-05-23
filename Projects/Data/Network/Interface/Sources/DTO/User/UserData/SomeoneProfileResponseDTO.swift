//
//  SomeoneProfileResponseDTO.swift
//  DataNetworkInterface
//
//  Created by HUNHIE LEE on 2/26/24.
//

import Foundation
import DomainUser
import DomainUserInterface

public struct SomeoneProfileResponseDTO: CommonResponseDTO {
  public let code: Int
  public let status: String
  public let message: String
  public let data: UserProfileData
  
  public struct UserProfileData: Decodable {
    let id: Int
    let nickname, birth, mbti: String
    let gender: Gender
    let authority: Authority
    let interests: [InterestsDTO]
    let address, imageURL, job, introduce, school: String?
    let blueCheck, unlock: Bool
    
    enum CodingKeys: String, CodingKey {
      case id, nickname, birth, gender, mbti, address, authority
      case imageURL = "imageUrl"
      case interests, job, introduce, school
      case blueCheck, unlock
    }
  }
  
  public func toDomain() -> SomeoneProfile {
    return SomeoneProfile(
      userId: data.id,
      nickname: data.nickname,
      birth: data.birth,
      gender: data.gender,
      mbti: data.mbti,
      address: data.address,
      imageUrl: data.imageURL,
      interests: data.interests.map { Interest(id: $0.id, name: $0.name)},
      job: data.job,
      introduce: data.introduce,
      school: data.school,
      blueCheck: data.blueCheck,
      authority: data.authority,
      unlock: data.unlock
    )
  }
}
