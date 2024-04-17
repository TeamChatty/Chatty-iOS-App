//
//  FeedResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation

public struct FeedResponseDTO: Decodable {
  public let postId: Int
  public let title: String
  public let content: String
  public let viewCount: Int
  public let createdAt: String // "2024-04-17T00:08:31.268Z"
  public let userId: Int
  public let nickname: String
  public let imageUrl: String
  
  public func toDomain() { }
}
