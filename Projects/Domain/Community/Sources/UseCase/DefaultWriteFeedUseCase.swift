//
//  DefaultWriteFeedUseCase.swift
//  DomainCommunityInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation
import RxSwift

import DomainCommunityInterface


public final class DefaultWriteFeedUseCase: WriteFeedUseCase {

  private let communityAPIRepository: CommunityAPIRepositoryProtocol
  
  public init(communityAPIRepository: CommunityAPIRepositoryProtocol) {
    self.communityAPIRepository = communityAPIRepository
  }
  
  public func execute(content: String, images: [Data]) -> Observable<WritedFeed> {
    return communityAPIRepository.writeFeed(content: content, images: images)
  }
}
