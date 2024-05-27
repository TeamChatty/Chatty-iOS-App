//
//  DefaultReportUseCase.swift
//  DomainCommunity
//
//  Created by 윤지호 on 5/3/24.
//

import Foundation
import RxSwift
import DomainCommunityInterface

public final class DefaultReportUseCase: ReportUseCase {
  private let communityAPIRepository: any CommunityAPIRepositoryProtocol
  
  public init(communityAPIRepository: any CommunityAPIRepositoryProtocol) {
    self.communityAPIRepository = communityAPIRepository
  }
  
  public func executeBlock(userId: Int) -> Observable<Int> {
    return communityAPIRepository.reportBlockUser(userId: userId)
  }
  
  public func executeReport(userId: Int, content: String) -> Observable<Int> {
    return communityAPIRepository.reportUser(userId: userId, content: content)
  }
}
