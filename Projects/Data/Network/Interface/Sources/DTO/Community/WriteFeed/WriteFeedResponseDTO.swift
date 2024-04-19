//
//  WriteFeedResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation
import DomainCommunity
import DomainCommunityInterface

public struct WriteFeedResponseDTO: CommonResponseDTO {
  public typealias Data = WritedFeedResponseDTO
  public let code: Int
  public let status: String
  public let message: String
  public let data: WritedFeedResponseDTO
  
  public func toDomain() -> WritedFeed {
    return data.toDomain()
  }
}

public struct WritedFeedResponseDTO: Decodable {
  public let id: Int
  public let title: String
  public let content: String
  public let userId: Int
  public let nickname:String
  public let profileImage: String
  public let postImages: [String]
  public let viewCount: Int
  
  public func toDomain() -> WritedFeed {
    return WritedFeed(id: self.id, title: self.title, content: self.content, userId: self.userId, nickname: self.nickname, profileImage: self.profileImage, postImages: self.postImages, viewCount: self.viewCount)
  }
}
