//
//  FeedListType+Extension.swift
//  FeatureFeedInterface
//
//  Created by 윤지호 on 4/26/24.
//

import Foundation
import DomainCommunityInterface

extension FeedPageType {
  var description: String {
    switch self {
    case .myPosts:
      return "첫 게시물을 작성해 보세요"
    case .myBookmark:
      return "다시 보고 싶은 글을 북마크 해보세요"
    case .myComments:
      return "댓글 단 글을 확인할 수 있어요"
    default:
      return ""
    }
  }
  
  var buttonTitle: String {
    switch self {
    case .myPosts:
      return "피드 글쓰기"
    case .myBookmark, .myComments:
      return "피드 둘러보기"
    default:
      return ""
    }
  }
}
