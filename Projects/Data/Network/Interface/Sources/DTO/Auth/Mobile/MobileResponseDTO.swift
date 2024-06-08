//
//  MobileResponseDTO.swift
//  DataNetworkInterface
//
//  Created by walkerhilla on 1/16/24.
//

import Foundation
import DomainAuthInterface

public struct MobileResponseDTO: CommonResponseDTO {
  public var code: Int
  public var status: String
  public var message: String
  public var data: AuthNumberResponse
  
  public func toDomain() -> AuthNumber {
    return data.toDomain()
  }
}

public struct AuthNumberResponse: Decodable {
  public let authNumber: String
  public let limitNumber: Int
  
  public func toDomain() -> AuthNumber {
    return AuthNumber(authNumber: authNumber, limitNumber: limitNumber)
  }
}
