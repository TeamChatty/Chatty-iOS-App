//
//  ReplyResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation
import DomainCommunityInterface

public struct ReplyResponseDTO: Decodable {
  public let postId: Int
  public let commentId: Int
  public let parentId: Int
  public let content: String
  public let createdAt: String // "2024-04-17T01:18:20.256Z"
  public let userId: Int
  public let nickname: String
  public let imageUrl: String?
  public let likeCount: Int
  public let like: Bool
  public let owner: Bool
  
  public func toDomain() -> Reply {
    return Reply(postId: postId, commentId: commentId, parentId: parentId, content: content, createdAt: createdAt, userId: userId, nickname: nickname, imageUrl: imageUrl, likeCount: likeCount, like: like, owner: owner)
  }
}
