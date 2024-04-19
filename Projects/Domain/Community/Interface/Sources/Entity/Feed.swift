//
//  Feed.swift
//  DomainCommunityInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation

public struct Feed {
  public let postId: Int
  public let title: String
  public let content: String
  public let viewCount: Int
  public let createdAt: String // "2024-04-17T00:08:31.268Z"
  public let userId: Int
  public let nickname: String
  public let imageUrl: String
  
  public init(postId: Int, title: String, content: String, viewCount: Int, createdAt: String, userId: Int, nickname: String, imageUrl: String) {
    self.postId = postId
    self.title = title
    self.content = content
    self.viewCount = viewCount
    self.createdAt = createdAt
    self.userId = userId
    self.nickname = nickname
    self.imageUrl = imageUrl
  }
}
