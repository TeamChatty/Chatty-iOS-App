//
//  DefaultGetFeedsPageUseCase.swift
//  DomainCommunity
//
//  Created by 윤지호 on 4/27/24.
//

import Foundation
import RxSwift
import DomainCommunityInterface
import Shared

public final class DefaultGetFeedsPageUseCase: GetFeedsPageUseCase {
  private let communityAPIRepository: any CommunityAPIRepositoryProtocol
  
  public init(communityAPIRepository: any CommunityAPIRepositoryProtocol) {
    self.communityAPIRepository = communityAPIRepository
  }
  
  public func execute(feedType: FeedPageType, lastPostId: Int, size: Int) -> Observable<[Feed]> {
    switch feedType {
    case .recent:
      return communityAPIRepository.getPosts(lastPostId: lastPostId, size: size)
    case .topLiked:
      return communityAPIRepository.getTopLikedPosts(lastLikeCount: lastPostId, size: size)
    case .myBookmark:
      return communityAPIRepository.getMyBookmarkPosts(lastBookmarkId: lastPostId, size: size)
    case .myPosts:
      return communityAPIRepository.getMyPosts(lastPostId: lastPostId, size: size)
    case .myComments:
      return .just([])
    }
  }
}
