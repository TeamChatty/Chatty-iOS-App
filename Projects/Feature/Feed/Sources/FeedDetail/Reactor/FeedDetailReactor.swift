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
  private let reportUseCase: ReportUseCase
  
  let cellCase: [DetailCellCase] = [.content, .comment]
  
  public enum Action {
    case viewDidLoad
    
    case bookmark(postId: Int, changedState: Bool)
    case favorite(postId: Int, changedState: Bool)
    
    case reportBlockUser(userId: Int)
    case reportPost(postId: Int)
  }
  
  public enum Mutation {
    case setFeed(Feed)
    
    case setLike(postId: Int, changedState: Bool)
    case setBookmark(postId: Int, changedState: Bool)
    
    case setBlockedId(userId: Int?)
    case setReportedId(postId: Int?)
    
    case setIsLoading(Bool)
    case setError(ErrorType?)
  }
  
  public struct State {
    var postId: Int
    var feed: Feed?
    
    var commentType: CommentType?
    
    var blockedId: Int?
    var reportedPostId: Int?
    
    var isLoading: Bool = false
    var errorState: ErrorType? = nil
  }
  
  public var initialState: State
  
  public init(getFeedUseCase: GetFeedUseCase, setBookmarkAndLikeUseCase: SetBookmarkAndLikeUseCase, reportUseCase: ReportUseCase, postId: Int) {
    self.getFeedUseCase = getFeedUseCase
    self.setBookmarkAndLikeUseCase = setBookmarkAndLikeUseCase
    self.reportUseCase = reportUseCase
    self.initialState = State(postId: postId)
  }
  
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
        .just(.setIsLoading(true)),
        getFeedUseCase.execute(postId: initialState.postId)
          .map { .setFeed($0) },
        .just(.setIsLoading(false)),
      ])
  
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
      
    case .reportBlockUser(userId: let userId):
      return .concat([
        .just(.setBlockedId(userId: nil)),
        reportUseCase.executeBlock(userId: userId)
          .map { _ in .setBlockedId(userId: userId) }
      ])
    case .reportPost(postId: let postId):
      return .concat([
        .just(.setReportedId(postId: nil)),
        reportUseCase.executePost(postId: postId)
          .map { _ in Mutation.setReportedId(postId: postId) }
      ])
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setFeed(let feed):
      newState.feed = feed
      
    case .setIsLoading(let bool):
      newState.isLoading = bool
    case .setLike(postId: let postId, changedState: let editedState):
      newState.feed?.like = editedState
      if let likeCount = newState.feed?.likeCount {
        newState.feed?.likeCount = editedState ? likeCount + 1 : likeCount - 1
      }
    case .setBookmark(postId: let postId, changedState: let editedState):
      newState.feed?.bookmark = editedState
    case .setBlockedId(userId: let userId):
      newState.blockedId = userId
    case .setReportedId(postId: let postId):
      newState.reportedPostId = postId
    case .setError(let error):
      newState.errorState = error
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

