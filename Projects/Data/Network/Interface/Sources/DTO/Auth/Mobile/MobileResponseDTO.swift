//
//  MobileResponseDTO.swift
//  DataNetworkInterface
//
//  Created by walkerhilla on 1/16/24.
//

import Foundation

public struct MobileResponseDTO: CommonResponseDTO {
  public var code: Int
  public var status: String
  public var message: String
  public var data: AuthNumber
  
  public func toDomain() -> Int {
    return data.limitNumber
  }
}

public struct AuthNumber: Decodable {
  public let authNumber: String
  public let limitNumber: Int
}
