//
//  DefaultGetCommetUseCase.swift
//  DomainCommunity
//
//  Created by 윤지호 on 5/8/24.
//

import Foundation
import RxSwift

import DomainCommunityInterface
import DomainUserInterface

public final class DefaultGetCommetUseCase: GetCommetUseCase {
  private let communityAPIRepository: CommunityAPIRepositoryProtocol
  private let userProfileRepository: UserProfileRepositoryProtocol
  
  public init(communityAPIRepository: CommunityAPIRepositoryProtocol, userProfileRepository: UserProfileRepositoryProtocol) {
    self.communityAPIRepository = communityAPIRepository
    self.userProfileRepository = userProfileRepository
  }
  
  public func executeComments(postId: Int, lastCommentId: Int64, size: Int) -> Observable<[FeedDetailComment]> {
    
    return communityAPIRepository.getComments(postId: postId, lastCommentId: lastCommentId, size: size)
      .map { comments in
        return comments.map { comment in
          return FeedDetailComment(
            isOwner: comment.owner,
            userId: comment.userId,
            commentId: comment.commentId,
            profileImage: comment.imageUrl,
            nickname: comment.nickname,
            content: comment.content,
            createdAt: comment.createdAt,
            isLike: comment.like,
            likeCount: comment.likeCount,
            childCount: comment.childCount,
            childReplys: [])
        }
      }
  }
  
  public func executeReplies(commentId: Int, lastCommentId: Int64, size: Int) -> Observable<[FeedDetailReply]> {

    return communityAPIRepository.getReplies(commentId: commentId, lastCommentId: lastCommentId, size: size)
      .map { replise in
        return replise.map { reply in
          return FeedDetailReply(
            isOwner: reply.owner,
            userId: reply.userId,
            commentId: reply.commentId,
            parentsId: reply.parentId,
            profileImage: reply.imageUrl,
            nickname: reply.nickname,
            content: reply.content,
            createdAt: reply.createdAt,
            isLike: reply.like,
            likeCount: reply.likeCount
          )
        }
      }
  }
}
