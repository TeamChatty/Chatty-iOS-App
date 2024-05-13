//
//  DefaultWriteCommentUseCase.swift
//  DomainCommunity
//
//  Created by 윤지호 on 5/8/24.
//

import Foundation
import RxSwift
import DomainCommunityInterface
import DomainUserInterface

public final class DefaultWriteCommentUseCase: WriteCommentUseCase {
  private let communityAPIRepository: CommunityAPIRepositoryProtocol
  private let userProfileRepository: UserProfileRepositoryProtocol

  public init(communityAPIRepository: CommunityAPIRepositoryProtocol, userProfileRepository: UserProfileRepositoryProtocol) {
    self.communityAPIRepository = communityAPIRepository
    self.userProfileRepository = userProfileRepository
  }
  
  public func executeComment(postId: Int, content: String) -> Observable<FeedDetailComment> {
    let userProfile = userProfileRepository.getUserProfile()
    
    return communityAPIRepository.writeComment(postId: postId, content: content)
      .map { [userProfile] comment in
        return FeedDetailComment(
          isOwner: comment.owner,
          userId: comment.userId,
          commentId: comment.commentId,
          profileImage: comment.imageUrl,
          nickname: userProfile.nickname ?? "",
          content: comment.content,
          createdAt: comment.createdAt,
          isLike: comment.like,
          likeCount: comment.likeCount,
          childCount: comment.childCount,
          childReplys: []
        )
      }
  }
  
  public func executeReply(postId: Int, commentId: Int, content: String) -> Observable<FeedDetailReply> {
    let userProfile = userProfileRepository.getUserProfile()

    return communityAPIRepository.writeReply(postId: postId, commentId: commentId, content: content)
      .map { [userProfile] reply in
        return FeedDetailReply(
          isOwner: reply.owner,
          userId: reply.userId,
          commentId: reply.commentId,
          parentsId: reply.parentId,
          nickname: userProfile.nickname ?? "",
          content: reply.content,
          createdAt: reply.createdAt,
          isLike: reply.like,
          likeCount: reply.likeCount
        )
      }

  }
}
