//
//  FeedMyCommentsState.swift
//  FeatureFeed
//
//  Created by 윤지호 on 5/18/24.
//

import Foundation

enum FeedMyCommentsState: Equatable {
  case loaded
  case loadedLastPage
  case loadedEmpty
  case paged(addedCount: Int)
  case lastPage
  case error
}
