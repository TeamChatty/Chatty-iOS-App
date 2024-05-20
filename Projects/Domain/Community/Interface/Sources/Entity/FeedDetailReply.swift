//
//  FeedDetailReply.swift
//  DomainCommunityInterface
//
//  Created by 윤지호 on 5/8/24.
//

import Foundation

public struct FeedDetailReply {
  public let isOwner: Bool
  public let isReply: Bool = true
  
  public let userId: Int
  public let commentId: Int
  public let parentsId: Int

  public var profileImage: String?
  public var nickname: String
  public var content: String
  public var createdAt: String
  public var isLike: Bool
  public var likeCount: Int
  
  public init(isOwner: Bool, userId: Int, commentId: Int, parentsId: Int, profileImage: String? = nil, nickname: String, content: String, createdAt: String, isLike: Bool, likeCount: Int) {
    self.isOwner = isOwner
    self.userId = userId
    self.commentId = commentId
    self.parentsId = parentsId
    self.profileImage = profileImage
    self.nickname = nickname
    self.content = content
    self.createdAt = createdAt
    self.isLike = isLike
    self.likeCount = likeCount
  }
}

extension FeedDetailReply: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.isOwner == rhs.isOwner && lhs.userId == rhs.userId && lhs.commentId == rhs.commentId && lhs.parentsId == rhs.parentsId && lhs.profileImage == rhs.profileImage && lhs.nickname == rhs.nickname && lhs.content == rhs.content && lhs.createdAt == rhs.createdAt && lhs.isLike == rhs.isLike && lhs.likeCount == rhs.likeCount
  }
}
