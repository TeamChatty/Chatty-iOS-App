//
//  CheckResponseDTO.swift
//  DataNetworkInterface
//
//  Created by HUNHIE LEE on 7.05.2024.
//

import Foundation

public struct CheckResponseDTO: CommonResponseDTO {
  public let code: Int
  public let status: String
  public let message: String
  public let data: Data
  
  public struct Data: Decodable {
    public let answer: Bool
  }
  
  public func toDomain() -> Bool {
    return data.answer
  }
}
