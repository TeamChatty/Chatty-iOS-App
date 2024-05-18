//
//  ProfileResponseDTO.swift
//  DataNetworkInterface
//
//  Created by HUNHIE LEE on 2.05.2024.
//

import Foundation

public struct ProfileResponseDTO: CommonResponseDTO {
  public let code: Int
  public let status: String
  public let message: String
  public let data: DataClass
  
  public struct DataClass: Decodable {
    let imageUrl: String?
  }
  
  public func toDomain() -> String? {
    return data.imageUrl
  }
}
