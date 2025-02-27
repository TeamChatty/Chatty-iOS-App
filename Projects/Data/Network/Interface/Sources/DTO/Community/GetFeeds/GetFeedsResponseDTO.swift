//
//  GetFeedsResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation
import DomainCommunityInterface

public struct GetFeedsResponseDTO: CommonResponseDTO {
  public typealias Data = [FeedResponseDTO]
  public var code: Int
  public var status: String
  public var message: String
  public var data: Data
  
  public func toDomain() -> [Feed] {
    return data.map { $0.toDomain() }
  }
}
