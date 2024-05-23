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
  public func writeFeed(title: String, content: String, images: [Data]) -> Observable<WritedFeed> {
    let requestDTO = WriteFeedRequestDTO(title: title, content: content, images: images)
    return communityAPIService.request(endPoint: .writePost(requestDTO), responseDTO: WriteFeedResponseDTO.self)
      .asObservable()
      .map { $0.toDomain() }
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
  
  public func reportPost(postId: Int) -> Observable<Int> {
    return communityAPIService.request(endPoint: .reportBlock(userId: postId), responseDTO: ReportBlockResponseDTO.self)
      .asObservable()
      .map { $0.data.blockedId }
  }
}
