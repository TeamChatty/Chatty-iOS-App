//
//  ReplyUpdateType.swift
//  FeatureFeed
//
//  Created by 윤지호 on 5/20/24.
//

import Foundation
import DomainCommunityInterface

public enum ReplyUpdateType: Equatable {
  case replySavedUpdateView(parentsId: Int)
  case replySavedUpdateCount(parentsId: Int, updatedChildCount: Int)
  case loaded(parentsId: Int, replies: [FeedDetailReply])
  case paged(parentsId: Int, replies: [FeedDetailReply])
  case removedReplies(parentsId: Int)
}


