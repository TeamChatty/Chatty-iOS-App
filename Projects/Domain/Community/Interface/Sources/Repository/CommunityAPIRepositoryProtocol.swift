//
//  CommunityAPIRepositoryProtocol.swift
//  DomainCommunityInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation
import RxSwift

public protocol CommunityAPIRepositoryProtocol: AnyObject {
  /// Write Post
  func writeFeed(title: String, content: String, images: [Data]) -> Observable<WritedFeed>
  
  /// Posts Page
  func getPosts(lastPostId: Int, size: Int) -> Observable<[Feed]>
  func getTopLikedPosts(lastLikeCount: Int, size: Int) -> Observable<[Feed]>
  func getMyBookmarkPosts(lastBookmarkId: Int, size: Int) -> Observable<[Feed]>
  func getMyPosts(lastPostId: Int, size: Int) -> Observable<[Feed]>

  /// Post
  func getPost(postId: Int) -> Observable<Feed>
  
  /// Comment
  func writeComment(postId: Int, content: String) -> Observable<Comment>
  func writeReply(postId: Int, commentId: Int, content: String) -> Observable<Reply>
  func getComments(postId: Int, lastCommentId: Int64, size: Int) -> Observable<[Comment]>
  func getReplies(commentId: Int, lastCommentId: Int64, size: Int) -> Observable<[Reply]>
  
  /// Like
  func setLike(postId: Int) -> Observable<Int>
  func deleteLike(postId: Int) -> Observable<Int>
  
  func setCommentLike(commentId: Int) -> Observable<Int>
  func deleteCommentLike(commentId: Int) -> Observable<Int>

  /// Bookmark
  func setBookmark(postId: Int) -> Observable<Int>
  func deleteBookmark(postId: Int) -> Observable<Int>
  
  /// Report
  func reportBlockUser(userId: Int) -> Observable<Int>
  func reportPost(postId: Int) -> Observable<Int>
}
