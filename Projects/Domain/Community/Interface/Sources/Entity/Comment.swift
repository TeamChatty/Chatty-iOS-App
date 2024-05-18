//
//  Comment.swift
//  DomainCommunityInterface
//
//  Created by 윤지호 on 5/5/24.
//

import Foundation

public struct Comment {
  public let postId: Int
  public let commentId: Int
  public let content: String
  public let createdAt: String // "2024-04-17T01:18:20.256Z",
  public var childCount: Int
  public let userId: Int
  public let nickname: String
  public let imageUrl: String?
  public var likeCount: Int
  public var like: Bool
  public let owner: Bool
  
  public init(postId: Int, commentId: Int, content: String, createdAt: String, childCount: Int, userId: Int, nickname: String, imageUrl: String?, likeCount: Int, like: Bool, owner: Bool) {
    self.postId = postId
    self.commentId = commentId
    self.content = content
    self.createdAt = createdAt
    self.childCount = childCount
    self.userId = userId
    self.nickname = nickname
    self.imageUrl = imageUrl
    self.likeCount = likeCount
    self.like = like
    self.owner = owner
  }
}
