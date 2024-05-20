//
//  GetFeedUseCase.swift
//  DomainCommunityInterface
//
//  Created by 윤지호 on 5/3/24.
//

import Foundation
import RxSwift

public protocol GetFeedUseCase {
  func execute(postId: Int) -> Observable<Feed>
}
