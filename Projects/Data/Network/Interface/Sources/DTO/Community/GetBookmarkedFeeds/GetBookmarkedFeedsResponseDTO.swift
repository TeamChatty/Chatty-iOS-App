//
//  GetBookmarkedFeedsResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 5/2/24.
//

import Foundation
import DomainCommunityInterface

public struct GetBookmarkedFeedsResponseDTO: CommonResponseDTO {
  public typealias Data = [ResponseDTO]
  
  public var code: Int
  public var status: String
  public var message: String
  public var data: Data
  
  public struct ResponseDTO: Decodable {
    public var bookmarkId: Int
    public var postListResponse: FeedResponseDTO
  }
  
  public func toDomain() -> [Feed] {
    return data.map { $0.postListResponse.toDomain() }
  }
}
