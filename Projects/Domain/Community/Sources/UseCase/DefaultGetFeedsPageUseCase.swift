//
//  DefaultGetFeedsPageUseCase.swift
//  DomainCommunity
//
//  Created by 윤지호 on 4/27/24.
//

import Foundation
import RxSwift
import DomainCommunityInterface

public final class DefaultGetFeedsPageUseCase: GetFeedsPageUseCase {
  private let communityAPIRepository: any CommunityAPIRepositoryProtocol
  
  public init(communityAPIRepository: any CommunityAPIRepositoryProtocol) {
    self.communityAPIRepository = communityAPIRepository
  }
  
  public func execute(lastPostId: Int, size: Int) -> Observable<[Feed]> {
    return communityAPIRepository.getPosts(lastPostId: lastPostId, size: size)
  }
}
