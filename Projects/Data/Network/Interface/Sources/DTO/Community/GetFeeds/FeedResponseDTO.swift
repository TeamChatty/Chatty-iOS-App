//
//  FeedResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation
import DomainCommunityInterface

public struct FeedResponseDTO: Decodable {
  public let postId: Int
  public let content: String
  public let viewCount: Int
  public let createdAt: String // "2024-04-17T00:08:31.268Z"
  public let userId: Int
  public let nickname: String
  public let imageUrl: String?
  public let postImages: [String]

  public let likeCount: Int
  public let commentCount: Int
  public let like: Bool
  public let owner: Bool
  public let bookmark: Bool
  
  public func toDomain() -> Feed { 
    return Feed(postId: postId, content: content, viewCount: viewCount, createdAt: createdAt, userId: userId, nickname: nickname, imageUrl: imageUrl, postImages: postImages, owner: owner, likeCount: likeCount, commentCount: commentCount, like: like, bookmark: bookmark)
  }
}
