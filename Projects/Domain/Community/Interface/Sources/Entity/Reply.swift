//
//  Reply.swift
//  DomainCommunityInterface
//
//  Created by 윤지호 on 5/8/24.
//

import Foundation

public struct Reply: Decodable {
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
  
  public init(postId: Int, commentId: Int, parentId: Int, content: String, createdAt: String, userId: Int, nickname: String, imageUrl: String?, likeCount: Int, like: Bool, owner: Bool) {
    self.postId = postId
    self.commentId = commentId
    self.parentId = parentId
    self.content = content
    self.createdAt = createdAt
    self.userId = userId
    self.nickname = nickname
    self.imageUrl = imageUrl
    self.likeCount = likeCount
    self.like = like
    self.owner = owner
  }
}
