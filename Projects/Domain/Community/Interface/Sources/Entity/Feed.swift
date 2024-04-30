//
//  Feed.swift
//  DomainCommunityInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation

public struct Feed {
  public let postId: Int
  public let content: String
  public let viewCount: Int
  public let createdAt: String // "2024-04-17T00:08:31.268Z"
  public let userId: Int
  public let nickname: String
  public let imageUrl: String?
  public let postImages: [String]
  public let owner: Bool
  
  public var likeCount: Int
  public var commentCount: Int
  public var like: Bool
  public var bookmark: Bool

  public init(postId: Int, content: String, viewCount: Int, createdAt: String, userId: Int, nickname: String, imageUrl: String?, postImages: [String], owner: Bool, likeCount: Int, commentCount: Int, like: Bool, bookmark: Bool) {
    self.postId = postId
    self.content = content
    self.viewCount = viewCount
    self.createdAt = createdAt
    self.userId = userId
    self.nickname = nickname
    self.imageUrl = imageUrl
    self.postImages = postImages
    self.owner = owner
    self.likeCount = likeCount
    self.commentCount = commentCount
    self.like = like
    self.bookmark = bookmark
  }
}
