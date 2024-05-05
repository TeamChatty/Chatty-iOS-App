//
//  FeedDetailComment.swift
//  FeatureFeedInterface
//
//  Created by 윤지호 on 5/5/24.
//

import Foundation

struct FeedDetailComment {
  let isOwner: Bool
  let isReply: Bool = false
  
  let userId: Int
  let commentId: Int
  
  var profileImage: String
  var nickname: String
  var content: String
  var createdAt: String
  var isLike: Bool
  var likeCount: Int
  
  var childCount: Int
  var childReplys: [FeedDetailReply]
}

struct FeedDetailReply {
  let isOwner: Bool
  let isReply: Bool = true
  
  let userId: Int
  let commentId: Int
  let parentsId: Int

  var profileImage: String
  var nickname: String
  var content: String
  var createdAt: String
  var isLike: Bool
  var likeCount: Int
}
