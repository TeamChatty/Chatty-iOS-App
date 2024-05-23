//
//  FeedDetailComment.swift
//  DomainCommunityInterface
//
//  Created by 윤지호 on 5/5/24.
//

import Foundation

public struct FeedDetailComment {
  public let isOwner: Bool
  public let isReply: Bool = false
  
  public let userId: Int
  public let commentId: Int
  
  public var profileImage: String?
  public var nickname: String
  public var content: String
  public var createdAt: String
  public var isLike: Bool
  public var likeCount: Int
  
  public var childCount: Int
  public var childReplys: [FeedDetailReply]
  
  public init(isOwner: Bool, userId: Int, commentId: Int, profileImage: String? = nil, nickname: String, content: String, createdAt: String, isLike: Bool, likeCount: Int, childCount: Int, childReplys: [FeedDetailReply]) {
    self.isOwner = isOwner
    self.userId = userId
    self.commentId = commentId
    self.profileImage = profileImage
    self.nickname = nickname
    self.content = content
    self.createdAt = createdAt
    self.isLike = isLike
    self.likeCount = likeCount
    self.childCount = childCount
    self.childReplys = childReplys
  }
}
