//
//  InterestsResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 3/7/24.
//

import Foundation
import DomainUserInterface

public struct InterestsResponseDTO: CommonResponseDTO {  
  public var code: Int
  public var status: String
  public var message: String
  public var data: [InterestsDTO]
  
  public func toDomain() -> Interests {
    return Interests(interests: data.map { $0.toDomain() })
  }
}

public struct InterestsDTO: Decodable {
  let id: Int
  let name: String
  
  public func toDomain() -> Interest {
    return Interest(
      id: self.id,
      name: self.name
    )
  }
}
