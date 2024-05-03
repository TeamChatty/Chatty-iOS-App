//
//  SetBookmarkAndLikeUseCase.swift
//  DomainCommunityInterface
//
//  Created by 윤지호 on 5/2/24.
//

import Foundation
import RxSwift

public protocol SetBookmarkAndLikeUseCase {
  func executeLike(changedState: Bool, postId: Int) -> Observable<Int>
  func executeBookmark(changedState: Bool, postId: Int) -> Observable<Int>
}
