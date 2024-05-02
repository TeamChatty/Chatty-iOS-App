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
  
  public func executeLike(nowState: Bool, postId: Int) -> Observable<Int> {
    switch nowState {
    case true:
      return communityAPIRepository.deleteLike(postId: postId)
    case false:
      return communityAPIRepository.setLike(postId: postId)
    }
  }
  
  public func executeBookmark(nowState: Bool, postId: Int) -> Observable<Int> {
    switch nowState {
    case true:
      return communityAPIRepository.deleteBookmark(postId: postId)
    case false:
      return communityAPIRepository.setBookmark(postId: postId)
    }
  }
}
