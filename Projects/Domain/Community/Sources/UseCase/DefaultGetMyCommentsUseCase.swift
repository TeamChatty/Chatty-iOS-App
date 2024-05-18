//
//  DefaultGetMyCommentsUseCase.swift
//  DomainCommunity
//
//  Created by 윤지호 on 5/18/24.
//

import Foundation
import RxSwift
import DomainCommunityInterface

public final class DefaultGetMyCommentsUseCase: GetMyCommentsUseCase {
 
  
  private let communityAPIRepository: any CommunityAPIRepositoryProtocol
  
  public init(communityAPIRepository: any CommunityAPIRepositoryProtocol) {
    self.communityAPIRepository = communityAPIRepository
  }

  public func execute(lastCommentId: Int64, size: Int) -> Observable<[Comment]> {
    return communityAPIRepository.getMyComments(lastCommentId: lastCommentId, size: size)
  }
}
