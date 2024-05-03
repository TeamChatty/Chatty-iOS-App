//
//  DefaultGetFeedUseCase.swift
//  DomainCommunity
//
//  Created by 윤지호 on 5/3/24.
//

import Foundation
import RxSwift
import DomainCommunityInterface

public final class DefaultGetFeedUseCase: GetFeedUseCase {
  private let communityAPIRepository: any CommunityAPIRepositoryProtocol
  
  public init(communityAPIRepository: any CommunityAPIRepositoryProtocol) {
    self.communityAPIRepository = communityAPIRepository
  }
  
  public func execute(postId: Int) -> Observable<Feed> {
    return communityAPIRepository.getPost(postId: postId)
  }
}
