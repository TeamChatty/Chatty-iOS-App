//
//  WriteCommentUseCase.swift
//  DomainCommunityInterface
//
//  Created by 윤지호 on 5/8/24.
//

import Foundation
import RxSwift

public protocol WriteCommentUseCase {
  func executeComment(postId: Int, content: String) -> Observable<FeedDetailComment>
  func executeReply(postId: Int, commentId: Int, content: String) -> Observable<FeedDetailReply>
}
