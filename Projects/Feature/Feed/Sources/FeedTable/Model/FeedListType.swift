//
//  FeedListType.swift
//  FeatureFeedInterface
//
//  Created by 윤지호 on 4/26/24.
//

import Foundation

enum FeedListType {
  case lastest
  case recommend
  case wirtedFeed
  case savedFeed
  
  var description: String {
    switch self {
    case .wirtedFeed:
      return "첫 게시물을 작성해 보세요"
    case .savedFeed:
      return "다시 보고 싶은 글을 북마크 해보세요"
    default:
      return ""
    }
  }
  
  var buttonTitle: String {
    switch self {
    case .wirtedFeed:
      return "피드 글쓰기"
    case .savedFeed:
      return "피드 둘러보기"
    default:
      return ""
    }
  }
}
