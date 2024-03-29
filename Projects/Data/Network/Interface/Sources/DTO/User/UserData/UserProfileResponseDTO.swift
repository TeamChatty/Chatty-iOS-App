//
//  UserProfileResponseDTO.swift
//  DataNetworkInterface
//
//  Created by HUNHIE LEE on 2/26/24.
//

import Foundation
import DomainUserInterface
import DomainUser

public struct UserProfileResponseDTO: CommonResponseDTO {
  public let code: Int
  public let status: String
  public let message: String
  public let data: UserProfileData
  
  public struct UserProfileData: Decodable {
    let id: Int
    let mobileNumber, nickname, birth, mbti: String
    let gender: Gender?
    let authority: Authority
    let interests: [String]
    let address, imageURL, job, introduce, school: String?
    let blueCheck, unlock: Bool
    
    enum CodingKeys: String, CodingKey {
      case id, mobileNumber, nickname, birth, gender, mbti, address, authority
      case imageURL = "imageUrl"
      case interests, job, introduce, school
      case blueCheck, unlock
    }
  }
  
  public func toDomain() -> SomeoneProfile {
    return SomeoneProfile(
      profile: .init(
        nickname: data.nickname,
        mobileNumber: data.mobileNumber,
        birth: data.birth,
        gender: data.gender,
        mbti: data.mbti,
        authority: data.authority, 
        address: data.address,
        imageUrl: data.imageURL,
        interests: data.interests.enumerated().map({ index, item in
            .init(id: index, name: item)
        }),
        job: data.job,
        introduce: data.introduce,
        school: data.school,
        blueCheck: data.blueCheck
        ),
      unlock: data.unlock
    )
  }
}
