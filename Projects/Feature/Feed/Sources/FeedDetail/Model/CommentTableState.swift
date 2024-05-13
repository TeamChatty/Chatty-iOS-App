//
//  CommentTableState.swift
//  FeatureFeed
//
//  Created by 윤지호 on 5/8/24.
//

import Foundation

enum CommentTableState: Equatable {
  case savedcomment
  case savedReply(parentsId: Int)
  case commentLoaded
  case commentLoadedLastPage
  case commentLoadedEmpty
  case commentPaged(addedCount: Int)
  case commentlastPage
  case error
}
