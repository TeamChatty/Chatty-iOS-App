//
//  DefaultSetBookmarkAndLikeUseCase.swift
//  DomainCommunity
//
//  Created by 윤지호 on 5/2/24.
//

import Foundation
import RxSwift
import DomainCommunityInterface

public final class DefaultSetBookmarkAndLikeUseCase: SetBookmarkAndLikeUseCase {
  private let communityAPIRepository: any CommunityAPIRepositoryProtocol
  
  public init(communityAPIRepository: any CommunityAPIRepositoryProtocol) {
    self.communityAPIRepository = communityAPIRepository
  }
  
  public func executeLike(changedState: Bool, postId: Int) -> Observable<Int> {
    switch changedState {
    case true:
      return communityAPIRepository.setLike(postId: postId)
    case false:
      return communityAPIRepository.deleteLike(postId: postId)
    }
  }
  
  public func executeBookmark(changedState: Bool, postId: Int) -> Observable<Int> {
    switch changedState {
    case true:
      return communityAPIRepository.setBookmark(postId: postId)
    case false:
      return communityAPIRepository.deleteBookmark(postId: postId)
    }
  }
}
