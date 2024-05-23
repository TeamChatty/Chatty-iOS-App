//
//  SetCommentLikeUseCase.swift
//  DomainCommunityInterface
//
//  Created by 윤지호 on 5/13/24.
//

import Foundation
import RxSwift

public protocol SetCommentLikeUseCase {
  func execute(changedState: Bool, commentId: Int) -> Observable<Int>
}
