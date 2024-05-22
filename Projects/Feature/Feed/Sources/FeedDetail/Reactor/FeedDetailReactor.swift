//
//  FeedDetailReactor.swift
//  FeatureFeed
//
//  Created by 윤지호 on 5/3/24.
//

import UIKit
import RxSwift
import ReactorKit

import DomainCommon
import DomainCommunityInterface

public final class FeedDetailReactor: Reactor {
  private let getFeedUseCase: GetFeedUseCase
  private let setBookmarkAndLikeUseCase: SetBookmarkAndLikeUseCase
<<<<<<< HEAD
  private let reportUseCase: ReportUseCase
  
=======
  private let setCommentLikeUseCase: SetCommentLikeUseCase
  private let reportUseCase: ReportUseCase
  
  private let getCommetUseCase: GetCommetUseCase
  private let writeCommentUseCase: WriteCommentUseCase
  
  
>>>>>>> feature/feature-feed-MyProfle-Detail_IOS-51
  let cellCase: [DetailCellCase] = [.content, .comment]
  
  public enum Action {
    case viewDidLoad
<<<<<<< HEAD
    
    case bookmark(postId: Int, changedState: Bool)
    case favorite(postId: Int, changedState: Bool)
    
=======
    case refresh
    case refreshSuccessWrited(commentId: Int)
    case scrollToNextPage
    
    ///  Feed
    case bookmark(postId: Int, changedState: Bool)
    case favorite(postId: Int, changedState: Bool)
    
    /// Comment
    case startComment(CommentInputType)
    case inputComment(String)
    case sendComment
    
    /// Reply
    case tabRepliesButton(parentsId: Int)
    case closeRepliesButton(parentsId: Int)
    case tabRepliesPageButton(parentsId: Int)
    
    /// Like
    case tabCommentLike(commentId: Int, changedState: Bool)
    case tabReplyLike(parentsId: Int, replyId: Int, changedState: Bool)

>>>>>>> feature/feature-feed-MyProfle-Detail_IOS-51
    case reportBlockUser(userId: Int)
    case reportPost(postId: Int)
  }
  
  public enum Mutation {
<<<<<<< HEAD
=======
    /// Feed
>>>>>>> feature/feature-feed-MyProfle-Detail_IOS-51
    case setFeed(Feed)
    
    case setLike(postId: Int, changedState: Bool)
    case setBookmark(postId: Int, changedState: Bool)
    
<<<<<<< HEAD
    case setBlockedId(userId: Int?)
    case setReportedId(postId: Int?)
    
=======
    case setCommentLike(commentId: Int, changedState: Bool)
    case setReplyLike(parentsId: Int, replyId: Int, changedState: Bool)
    
    /// Comment
    case setComments(comments: [FeedDetailComment])
    case setCommentsRefresh(comments: [FeedDetailComment])
    case setNextCommentsPage(comments: [FeedDetailComment])
    case setCommentInputType(CommentInputType)
    case setInputedText(String)
    
    case setReplyUpdateType(ReplyUpdateType?)
    
    /// WriteComment
    case setReloadCommentsforSaved([FeedDetailComment])
    case setReloadReplyforSaved(FeedDetailReply)
    
    case setBlockedId(userId: Int?)
    case setReportedId(postId: Int?)
    
    case setTableState
    case setIsFetchingCommentPage(Bool)
    case setIsReloading(Bool)
>>>>>>> feature/feature-feed-MyProfle-Detail_IOS-51
    case setIsLoading(Bool)
    case setError(ErrorType?)
  }
  
  public struct State {
    var postId: Int
    var feed: Feed?
    
<<<<<<< HEAD
    var commentType: CommentType?
=======
    var comments: [FeedDetailComment] = []
    var replys: [FeedDetailReply] = []
    
    var commentInputType: CommentInputType? = nil
    var commentTableState: CommentTableState? = nil
    var inputedText: String = ""
    
    var replyUpdateType: ReplyUpdateType? = nil
>>>>>>> feature/feature-feed-MyProfle-Detail_IOS-51
    
    var blockedId: Int?
    var reportedPostId: Int?
    
<<<<<<< HEAD
=======
    var isFetchingComment: Bool = false
    var isReloading: Bool = false
>>>>>>> feature/feature-feed-MyProfle-Detail_IOS-51
    var isLoading: Bool = false
    var errorState: ErrorType? = nil
  }
  
  public var initialState: State
  
<<<<<<< HEAD
  public init(getFeedUseCase: GetFeedUseCase, setBookmarkAndLikeUseCase: SetBookmarkAndLikeUseCase, reportUseCase: ReportUseCase, postId: Int) {
    self.getFeedUseCase = getFeedUseCase
    self.setBookmarkAndLikeUseCase = setBookmarkAndLikeUseCase
    self.reportUseCase = reportUseCase
    self.initialState = State(postId: postId)
  }
  
=======
  public init(getFeedUseCase: GetFeedUseCase, setBookmarkAndLikeUseCase: SetBookmarkAndLikeUseCase, setCommentLikeUseCase: SetCommentLikeUseCase, reportUseCase: ReportUseCase, getCommetUseCase: GetCommetUseCase, writeCommentUseCase: WriteCommentUseCase, postId: Int) {
    self.getFeedUseCase = getFeedUseCase
    self.setBookmarkAndLikeUseCase = setBookmarkAndLikeUseCase
    self.setCommentLikeUseCase = setCommentLikeUseCase
    self.reportUseCase = reportUseCase
    self.getCommetUseCase = getCommetUseCase
    self.writeCommentUseCase = writeCommentUseCase
    self.initialState = State(postId: postId)
  }
  
  var newPageIndexPath: [IndexPath] {
    guard let tableState = currentState.commentTableState else { return [] }
    
    switch tableState {
    case .commentPaged(let addedCount):
      var indexPaths: [IndexPath] = []
      let lastRowIndex: Int = currentState.comments.count - addedCount
      for count in 0..<addedCount {
        indexPaths.append(IndexPath(row: lastRowIndex + count, section: 0))
      }
      return indexPaths
    default:
      return []
    }
  }
  
>>>>>>> feature/feature-feed-MyProfle-Detail_IOS-51
  public enum ErrorType: Error {
    case unknownError
    
    var description: String {
      switch self {
      case .unknownError:
        return "문제가 생겼어요. 다시 시도해주세요."
      }
    }
  }
}

extension FeedDetailReactor {
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return .concat([
<<<<<<< HEAD
        .just(.setIsLoading(true)),
        getFeedUseCase.execute(postId: initialState.postId)
          .map { .setFeed($0) },
        .just(.setIsLoading(false)),
      ])
  
=======
        .just(.setTableState),
        .just(.setIsLoading(true)),
        getFeedUseCase.execute(postId: initialState.postId)
          .map { .setFeed($0) },
        getCommetUseCase.executeComments(postId: initialState.postId, lastCommentId: Int64.max, size: 10)
          .map { .setComments(comments: $0) },
        .just(.setIsLoading(false)),
      ])
      
    case .refresh:
      return .concat([
        .just(.setTableState),
        .just(.setIsReloading(true)),
        getFeedUseCase.execute(postId: initialState.postId)
          .map { .setFeed($0) },
        getCommetUseCase.executeComments(postId: initialState.postId, lastCommentId: Int64.max, size: 10)
          .map { .setCommentsRefresh(comments: $0) },
        .just(.setIsReloading(false)),
      ])
    case .refreshSuccessWrited(commentId: let commentId):
      return .concat([
        .just(.setTableState),
        .just(.setIsLoading(true)),
        getFeedUseCase.execute(postId: initialState.postId)
          .map { .setFeed($0) },
        getCommetUseCase.executeComments(postId: initialState.postId, lastCommentId: Int64.max, size: 10)
          .map { .setCommentsRefresh(comments: $0) },
        .just(.setIsLoading(false)),
      ])
    case .scrollToNextPage:
      let lastPostId = currentState.comments.last?.commentId ?? Int.max
      return .concat([
        .just(.setTableState),
        .just(.setIsFetchingCommentPage(true)),
        getCommetUseCase.executeComments(postId: initialState.postId, lastCommentId: Int64(lastPostId), size: 10)
          .map { .setNextCommentsPage(comments: $0) },
        .just(.setIsFetchingCommentPage(false)),
      ])
      
      /// Feed
>>>>>>> feature/feature-feed-MyProfle-Detail_IOS-51
    case .bookmark(let postId, let changedState):
      if currentState.feed?.bookmark == changedState {
        return .just(.setIsLoading(false))
      } else {
        return setBookmarkAndLikeUseCase.executeBookmark(changedState: changedState, postId: postId)
          .map { [changedState] postId in
            return .setBookmark(postId: postId, changedState: changedState)
          }
      }
          
    
    case .favorite(let postId, let changedState):
      if currentState.feed?.like == changedState {
        return .just(.setIsLoading(false))
      } else {
        return setBookmarkAndLikeUseCase.executeLike(changedState: changedState, postId: postId)
          .map { [changedState] postId in
            return .setLike(postId: postId, changedState: changedState)
          }
      }
<<<<<<< HEAD
      
=======

      
    /// Comment
    case .startComment(let type):
      return .just(.setCommentInputType(type))
      
    case .inputComment(let text):
      return .just(.setInputedText(text))
      
    case .sendComment:
      switch currentState.commentInputType {
      case .comment:
        return .concat([
          .just(.setTableState),
          .just(.setIsLoading(true)),
          writeCommentUseCase.executeComment(postId: initialState.postId, content: currentState.inputedText)
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<[FeedDetailComment]> in
              return owner.getCommetUseCase.executeComments(postId: owner.initialState.postId, lastCommentId: Int64.max, size: 10)
            }
            .map { .setReloadCommentsforSaved($0) },
          
          .just(.setIsLoading(false))
        ])
        
      case .reply(let commentId):
        guard let index = currentState.comments.firstIndex(where: { $0.commentId == commentId}) else { return .concat([])}
        
        let parentsComment = currentState.comments[index]
        
        if parentsComment.childReplys.isEmpty && parentsComment.childCount < 10 {
          return .concat([
            .just(.setReplyUpdateType(nil)),
            getCommetUseCase.executeReplies(commentId: commentId, lastCommentId: 0, size: 10)
              .map { .setReplyUpdateType(.loaded(parentsId: commentId, replies: $0)) }
          ])
        } else {
          return .concat([
            .just(.setReplyUpdateType(nil)),
            .just(.setIsLoading(true)),
            writeCommentUseCase.executeReply(postId: initialState.postId, commentId: commentId, content: currentState.inputedText)
              .map { .setReloadReplyforSaved($0) }
            ,
            .just(.setIsLoading(false))
          ])
        }
        
        
      default:
        return .just(.setIsLoading(false))
      }
      
      /// Reply
    case .tabRepliesButton(let parentsId):
      return .concat([
        .just(.setReplyUpdateType(nil)),
        getCommetUseCase.executeReplies(commentId: parentsId, lastCommentId: 0, size: 10)
          .map { .setReplyUpdateType(.loaded(parentsId: parentsId, replies: $0)) }
      ])
    case .closeRepliesButton(let parentsId):
      return .concat([
        .just(.setReplyUpdateType(nil)),
        .just(.setReplyUpdateType(.removedReplies(parentsId: parentsId)))
      ])
    case .tabRepliesPageButton(let parentsId):
      if let index = currentState.comments.firstIndex(where: { $0.commentId == parentsId }),
         let lastComment = currentState.comments[index].childReplys.last {
        return .concat([
          .just(.setReplyUpdateType(nil)),
          getCommetUseCase.executeReplies(commentId: parentsId, lastCommentId: Int64(lastComment.commentId), size: 10)
            .map { .setReplyUpdateType(.paged(parentsId: parentsId, replies: $0)) }
        ])
      } else {
        return .concat([])
      }
      
    /// Like
    case .tabCommentLike(commentId: let commentId, changedState: let changedState):
      if let nowState = currentState.comments.firstIndex(where: { $0.commentId == commentId }),
         currentState.comments[nowState].isLike == changedState{
        return .just(.setIsLoading(false))
      } else {
        return setCommentLikeUseCase.execute(changedState: changedState, commentId: commentId)
          .map { [changedState] postId in
            return .setCommentLike(commentId: commentId, changedState: changedState)
          }
      }
     
    case .tabReplyLike(let parentsId, let replyId, let changedState):
      if let parentsIndex = currentState.comments.firstIndex(where: { $0.commentId == parentsId }),
         let replyIndex = currentState.comments[parentsIndex].childReplys.firstIndex(where: { $0.commentId == replyId }),
         currentState.comments[parentsIndex].childReplys[replyIndex].isLike == changedState {
        return .just(.setIsLoading(false))
      } else {
        return setCommentLikeUseCase.execute(changedState: changedState, commentId: replyId)
          .map { [changedState] postId in
            return .setReplyLike(parentsId: parentsId, replyId: replyId, changedState: changedState)
          }
      }
      
    /// Report
>>>>>>> feature/feature-feed-MyProfle-Detail_IOS-51
    case .reportBlockUser(userId: let userId):
      return .concat([
        .just(.setBlockedId(userId: nil)),
        reportUseCase.executeBlock(userId: userId)
          .map { _ in .setBlockedId(userId: userId) }
      ])
    case .reportPost(postId: let postId):
      return .concat([
        .just(.setReportedId(postId: nil)),
<<<<<<< HEAD
        reportUseCase.executePost(postId: postId)
=======
        reportUseCase.executeReport(userId: postId)
>>>>>>> feature/feature-feed-MyProfle-Detail_IOS-51
          .map { _ in Mutation.setReportedId(postId: postId) }
      ])
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setFeed(let feed):
      newState.feed = feed
      
    /// Feed
    case .setLike(postId: let postId, changedState: let editedState):
      newState.feed?.like = editedState
      if let likeCount = newState.feed?.likeCount {
        newState.feed?.likeCount = editedState ? likeCount + 1 : likeCount - 1
      }
    case .setBookmark(postId: let postId, changedState: let editedState):
      newState.feed?.bookmark = editedState
      
    /// Comment
    case .setComments(comments: let comments):
      newState.comments = comments
      
      if comments.isEmpty {
        newState.commentTableState = .commentLoadedEmpty
      } else if comments.count == currentState.feed?.commentCount {
        newState.commentTableState = .commentLoadedLastPage
      } else if comments.count < 10 {
        newState.commentTableState = .commentLoadedLastPage
      } else {
        newState.commentTableState = .commentLoaded
      }
      
    case .setCommentsRefresh(comments: let comments):
      newState.comments = comments
      
      if comments.isEmpty {
        newState.commentTableState = .commentLoadedEmpty
      } else if comments.count < 10 {
        newState.commentTableState = .commentLoadedLastPage
      } else {
        newState.commentTableState = .commentLoaded
      }
      
    case .setNextCommentsPage(comments: let comments):
      newState.comments += comments
      
      if comments.count < 10 {
        newState.commentTableState = .commentlastPage
      } else {
        newState.commentTableState = .commentPaged(addedCount: comments.count)
      }
      
    /// Reply
    case .setReplyUpdateType(let type):
      switch type {
      case .loaded(let parentsId, let replies):
        if let index = newState.comments.firstIndex(where: { $0.commentId == parentsId }) {
          newState.comments[index].childReplys = replies
        }
      case .paged(let parentsId, let replies):
        if let index = newState.comments.firstIndex(where: { $0.commentId == parentsId }) {
          newState.comments[index].childReplys += replies
        }
      case .removedReplies(let parentsId):
        if let index = newState.comments.firstIndex(where: { $0.commentId == parentsId }) {
          newState.comments[index].childReplys.removeAll()
        }
      default: break
      }
      newState.replyUpdateType = type

    /// like Comment / Reply
    case .setCommentLike(let commentId, let changedState):
      if let commentIndex = currentState.comments.firstIndex(where: { $0.commentId == commentId }) {
        let likeCount = newState.comments[commentIndex].likeCount
        newState.comments[commentIndex].isLike = changedState
        newState.comments[commentIndex].likeCount = changedState ? likeCount + 1 : likeCount - 1
      }
              
    case .setReplyLike(parentsId: let parentsId, replyId: let replyId, changedState: let changedState):
      if let parentsIndex = currentState.comments.firstIndex(where: { $0.commentId == parentsId }),
         let replyIndex = currentState.comments[parentsIndex].childReplys.firstIndex(where: { $0.commentId == replyId }) {
        newState.comments[parentsIndex].childReplys[replyIndex].isLike = changedState
        
        let likeCount = newState.comments[parentsIndex].childReplys[replyIndex].likeCount
        
        if likeCount > 0 {
          newState.comments[parentsIndex].childReplys[replyIndex].likeCount = changedState ? likeCount + 1 : likeCount - 1
        } else {
          newState.comments[parentsIndex].childReplys[replyIndex].likeCount = changedState ? likeCount + 1 : likeCount
        }
        
      }
      
    /// Write Comment
    case .setCommentInputType(let type):
      newState.commentInputType = type

    case .setInputedText(let text):
      newState.inputedText = text
      
    case .setReloadCommentsforSaved(let comments):
      newState.comments = comments
      
      if comments.isEmpty {
        newState.commentTableState = .commentLoadedEmpty
      } else if comments.count == currentState.feed?.commentCount {
        newState.commentTableState = .commentLoadedLastPage
      } else if comments.count < 10 {
        newState.commentTableState = .commentLoadedLastPage
      } else {
        newState.commentTableState = .commentLoaded
      }
      newState.feed?.commentCount += 1
      newState.commentInputType = .cancel
      
    case .setReloadReplyforSaved(let reply):
      if let index = newState.comments.firstIndex(where: { $0.commentId == reply.parentsId}) {

        let parentsComment = newState.comments[index]
        
        /// 1. 닫혀 있을 시 (리스트가 없을 시)
        if parentsComment.childReplys.isEmpty {
            newState.replyUpdateType = .replySavedUpdateCount(parentsId: reply.parentsId, updatedChildCount: parentsComment.childCount + 1)
          
          
        /// 2. 열려 있을 시 (리스트가 있을 시)
        } else {
          
          /// 2-1  대댓글이 추가되어야 될 시 (리스트가 전부 불러와졌을 경우)
          if parentsComment.childReplys.count < 10 {
            newState.comments[index].childReplys.append(reply)
            newState.replyUpdateType = .replySavedUpdateView(parentsId: reply.parentsId)
            
          /// 2-2  대댓글이 추가되어야 될 시 (현재까지 전부 불러와져 있을 경우)
          } else if parentsComment.childReplys.count == parentsComment.childCount {
            newState.comments[index].childReplys.append(reply)
            newState.replyUpdateType = .replySavedUpdateView(parentsId: reply.parentsId)
            
          /// 2-3 ChildCount만 추가될 시
          } else {
            newState.replyUpdateType = .replySavedUpdateCount(parentsId: reply.parentsId, updatedChildCount: parentsComment.childCount + 1)
          }
        }
        
        newState.comments[index].childCount += 1
        newState.commentInputType = .cancel
      }

    /// Report
    case .setBlockedId(userId: let userId):
      newState.blockedId = userId
    case .setReportedId(postId: let postId):
      newState.reportedPostId = postId
<<<<<<< HEAD
    case .setError(let error):
      newState.errorState = error
=======
      
    case .setError(let error):
      newState.errorState = error
    case .setIsLoading(let bool):
      newState.isLoading = bool
   
    case .setTableState:
      newState.commentTableState = nil
    case .setIsFetchingCommentPage(let bool):
      newState.isFetchingComment = bool
    case .setIsReloading(let bool):
      newState.isReloading = bool
>>>>>>> feature/feature-feed-MyProfle-Detail_IOS-51
    }
    return newState
  }
}

extension Error {
  func toMutation() -> Observable<FeedDetailReactor.Mutation> {
    let errorMutation: Observable<FeedDetailReactor.Mutation> = {
      guard let error = self as? NetworkError else {
        return .just(.setError(.unknownError))
      }
      switch error.errorCase {
      default:
        return .just(.setError(.unknownError))
      }
    }()
    
    return Observable.concat([
      errorMutation
    ])
  }
}

