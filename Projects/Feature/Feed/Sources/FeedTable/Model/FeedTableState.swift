//
//  FeedTableState.swift
//  FeatureFeed
//
//  Created by 윤지호 on 5/2/24.
//

import Foundation

enum FeedTableState: Equatable {
  case loaded
  case loadedLastPage
  case loadedEmpty
  case paged(addedCount: Int)
  case lastPage
  case error
}
