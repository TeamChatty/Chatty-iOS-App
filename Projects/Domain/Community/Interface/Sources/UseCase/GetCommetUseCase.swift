//
//  GetCommetUseCase.swift
//  DomainCommunityInterface
//
//  Created by 윤지호 on 5/8/24.
//

import Foundation
import RxSwift

public protocol GetCommetUseCase {
  func executeComments(postId: Int, lastCommentId: Int64, size: Int) -> Observable<[FeedDetailComment]>
  func executeReplies(commentId: Int, lastCommentId: Int64, size: Int) -> Observable<[FeedDetailReply]>
}
