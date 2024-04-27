//
//  SaveUserProfileResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 1/25/24.
//

import Foundation
import DomainUserInterface

public struct SaveUserProfileResponseDTO: CommonResponseDTO {
  public let code: Int
  public let status: String
  public let message: String
  public let data: UserProfileReponseDTO
  
  public func toDomain() -> UserProfile {
    return data.toDomain()
  }
}
