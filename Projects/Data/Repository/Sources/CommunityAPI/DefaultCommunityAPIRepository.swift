//
//  DefaultCommunityAPIRepository.swift
//  DataRepositoryInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation
import RxSwift
import Moya

import DomainCommunityInterface
import DataNetworkInterface
import DataRepositoryInterface

public final class DefaultCommunityAPIRepository: CommunityAPIRepository {
  
  private let communityAPIService: any CommunityAPIService
  
  public init(communityAPIService: any CommunityAPIService) {
    self.communityAPIService = communityAPIService
  }
  /// Write Post
  public func writeFeed(content: String, images: [Data]) -> Observable<WritedFeed> {
    let requestDTO = WriteFeedRequestDTO(content: content, images: images)
        
    return communityAPIService.requestUplodFeedObs(endPoint: .writePost(requestDTO), responseDTO: WriteFeedResponseDTO.self)
      .asObservable()
      .map { $0.toDomain() }
    
//    return communityAPIService.request(endPoint: .writePost(requestDTO), responseDTO: WriteFeedResponseDTO.self)
//      .asObservable()
//      .map { $0.toDomain() }
  }
  
  /// Posts Page
  public func getPosts(lastPostId: Int, size: Int) -> Observable<[Feed]> {
    let requestDTO = GetFeedPageRequestDTO(lastPostId: lastPostId, size: size)
    
    return communityAPIService.request(endPoint: .getPosts(requestDTO), responseDTO: GetFeedsResponseDTO.self)
      .asObservable()
      .map { $0.toDomain() }
  }
  
  public func getTopLikedPosts(lastLikeCount: Int, size: Int) -> Observable<[Feed]> {
    let requestDTO = GetFeedPageRequestDTO(lastPostId: lastLikeCount, size: size)
    
    return communityAPIService.request(endPoint: .getTopLikedPosts(requestDTO), responseDTO: GetFeedsResponseDTO.self)
      .asObservable()
      .map { $0.toDomain() }
  }
  
  public func getMyBookmarkPosts(lastBookmarkId: Int, size: Int) -> Observable<[Feed]> {
    let requestDTO = GetFeedPageRequestDTO(lastPostId: lastBookmarkId, size: size)
    
    return communityAPIService.request(endPoint: .getMyBookmarkPosts(requestDTO), responseDTO: GetBookmarkedFeedsResponseDTO.self)
      .asObservable()
      .map { $0.toDomain() }
  }
  
  public func getMyPosts(lastPostId: Int, size: Int) -> Observable<[Feed]> {
    let requestDTO = GetFeedPageRequestDTO(lastPostId: lastPostId, size: size)
    
    return communityAPIService.request(endPoint: .getMyPosts(requestDTO), responseDTO: GetFeedsResponseDTO.self)
      .asObservable()
      .map { $0.toDomain() }
  }
  
  /// Post
  public func getPost(postId: Int) -> Observable<Feed> {
    let requestId = PostRequestId(postId: postId)

    return communityAPIService.request(endPoint: .getPost(requestId), responseDTO: GetFeedResponseDTO.self)
      .asObservable()
      .map { $0.toDomain() }
  }
    
  /// Comment
  public func writeComment(postId: Int, content: String) -> Observable<Comment> {
    let requestId = PostRequestId(postId: postId)
    let requestDTO = WriteCommonCommentReqeustDTO(content: content)
    
    return communityAPIService.request(endPoint: .writeComment(requestIds: requestId, requestDTO: requestDTO), responseDTO: WriteCommentResponseDTO.self)
      .map { $0.toDomain() }
      .asObservable()
  }
  
  public func writeReply(postId: Int, commentId: Int, content: String) -> Observable<Reply> {
    let requestId = CommentRequestIds(postId: postId, commentId: commentId)
    let requestDTO = WriteCommonCommentReqeustDTO(content: content)
    
    return communityAPIService.request(endPoint: .writeCommentReply(requestIds: requestId, requestDTO: requestDTO), responseDTO: WriteReplyResponseDTO.self)
      .map { [commentId] response in
        return response.toDomain(parentId: commentId)
      }
      .asObservable()
  }
  
  public func getComments(postId: Int, lastCommentId: Int64, size: Int) -> Observable<[Comment]> {
    let requestId = GetCommnetsRequestDTO(postId: postId, lastCommentId: lastCommentId, size: size)
    
    return communityAPIService.request(endPoint: .getComments(requestId), responseDTO: GetCommnetsResponseDTO.self)
      .map { $0.toDomain() }
      .asObservable()
  }
  
  public func getReplies(commentId: Int, lastCommentId: Int64, size: Int) -> Observable<[Reply]> {
    let requestId = GetRepliesRequestDTO(commentId: commentId, lastCommentId: lastCommentId, size: size)
    
    return communityAPIService.request(endPoint: .getCommentReplies(requestId), responseDTO: GetRepliesResponseDTO.self)
      .map { $0.toDomain() }
      .asObservable()
  }
  
  public func getMyComments(lastCommentId: Int64, size: Int) -> Observable<[Comment]> {
    let requestDTO = GetMyCommnetsRequestDTO(lastCommentId: lastCommentId, size: size)
    
    return communityAPIService.request(endPoint: .getMyComments(requestDTO), responseDTO: GetCommnetsResponseDTO.self)
      .map { $0.toDomain() }
      .asObservable()
  }
  
  
  /// Like
  /// Post Id를 반환
  public func setLike(postId: Int) -> Observable<Int> {
    let requestId = PostRequestId(postId: postId)
    return communityAPIService.request(endPoint: .postLike(requestId), responseDTO: PostLikeResponseDTO.self)
      .asObservable()
      .map { $0.data.postId }
  }
  
  public func deleteLike(postId: Int) -> Observable<Int> {
    let requestId = PostRequestId(postId: postId)
    return communityAPIService.request(endPoint: .postLikeDelete(requestId), responseDTO: PostLikeResponseDTO.self)
      .asObservable()
      .map { $0.data.postId }
  }
  
  public func setCommentLike(commentId: Int) -> Observable<Int> {
    return communityAPIService.request(endPoint: .commentLike(commentId: commentId), responseDTO: CommentLikeResponseDTO.self)
      .asObservable()
      .map { $0.data.commentId }
  }
  
  public func deleteCommentLike(commentId: Int) -> Observable<Int> {
    return communityAPIService.request(endPoint: .commentLikeDelete(commentId: commentId), responseDTO: CommentLikeResponseDTO.self)
      .asObservable()
      .map { $0.data.commentId }
  }
  
  /// Bookmark
  /// Post Id를 반환
  public func setBookmark(postId: Int) -> Observable<Int> {
    let requestId = PostRequestId(postId: postId)
    return communityAPIService.request(endPoint: .postBookmark(requestId), responseDTO: PostBookmarkResponseDTO.self)
      .asObservable()
      .map { $0.data.postId }
  }
  
  public func deleteBookmark(postId: Int) -> Observable<Int> {
    let requestId = PostRequestId(postId: postId)
    return communityAPIService.request(endPoint: .postBookmarkDelete(requestId), responseDTO: PostBookmarkResponseDTO.self)
      .asObservable()
      .map { $0.data.postId }
  }

  public func reportBlockUser(userId: Int) -> Observable<Int> {
    return communityAPIService.request(endPoint: .reportBlock(userId: userId), responseDTO: ReportBlockResponseDTO.self)
      .asObservable()
      .map { $0.data.blockedId }
  }
  
  public func reportUser(userId: Int, content: String) -> Observable<Int> {
    let requestDTO = ReportUserRequestDTO(content: content)
    return communityAPIService.request(endPoint: .reportUser(userId: userId, content: requestDTO), responseDTO: ReportUserResponseDTO.self)
      .asObservable()
      .map { $0.data.reportedId }
  }
}
