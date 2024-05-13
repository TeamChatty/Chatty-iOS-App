//
//  DefaultSetCommentLikeUseCase.swift
//  DomainCommunity
//
//  Created by 윤지호 on 5/13/24.
//

import Foundation
import RxSwift

import DomainCommunityInterface

public final class DefaultSetCommentLikeUseCase: SetCommentLikeUseCase {
  private let communityAPIRepository: any CommunityAPIRepositoryProtocol
  
  public init(communityAPIRepository: any CommunityAPIRepositoryProtocol) {
    self.communityAPIRepository = communityAPIRepository
  }
  
  public func execute(changedState: Bool, commentId: Int) -> Observable<Int> {
    switch changedState {
    case true:
      return communityAPIRepository.setCommentLike(commentId: commentId)
    case false:
      return communityAPIRepository.deleteCommentLike(commentId: commentId)
    }
  }
}
