//
//  FeedMyCommentTableViewReactor.swift
//  FeatureFeed
//
//  Created by 윤지호 on 5/18/24.
//

import ReactorKit
import UIKit
import SharedDesignSystem
import DomainCommon
import DomainCommunityInterface

final class FeedMyCommentTableViewReactor: Reactor {
  private let getMyCommentsUseCase: GetMyCommentsUseCase
  private let setCommentLikeUseCase: SetCommentLikeUseCase

  enum Action {
    case viewDidLoad
    case refresh
    case scrollToNextPage
    
    case favorite(commentId: Int, changedState: Bool)
    case showDetail(postId: Int)

  }
  
  enum Mutation {
    case setList([Comment])
    case setListRefresh([Comment])
    case setNextPage(comments: [Comment])
    case setTableState
    
    case setLike(commentId: Int, changedState: Bool)
    
    case setIsFetchingPage(Bool)
    case isReloading(Bool)
    case setIsLoading(Bool)
    case setError(ErrorType?)
  }
  
  struct State {
    var comments: [Comment] = []
    
    var tableState: FeedMyCommentsState? = nil
    var isFetchingPage: Bool = false
    
    var isReloading: Bool = false
    var isLoading: Bool = false
    var errorState: ErrorType? = nil
  }
  
  var newPageIndexPath: [IndexPath] {
    guard let tableState = currentState.tableState else { return [] }
    
    switch tableState {
    case .paged(let addedCount):
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
  
  
  var initialState: State
  
  public init(getMyCommentsUseCase: GetMyCommentsUseCase, setCommentLikeUseCase: SetCommentLikeUseCase) {
    self.getMyCommentsUseCase = getMyCommentsUseCase
    self.setCommentLikeUseCase = setCommentLikeUseCase
    self.initialState = State()
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

extension FeedMyCommentTableViewReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return .concat([
        .just(.setTableState),
        .just(.setIsLoading(true)),
        getMyCommentsUseCase.execute(lastCommentId: Int64.max, size: 10)
          .map { .setList($0) }
          .catch { error -> Observable<FeedMyCommentTableViewReactor.Mutation> in
            return error.toMutation()
          },
        .just(.setIsLoading(false)),
      ])
      
    case .refresh:
      return .concat([
        .just(.setTableState),
        .just(.isReloading(true)),
        getMyCommentsUseCase.execute(lastCommentId: Int64.max, size: 10)
          .map { .setList($0) }
          .catch { error -> Observable<FeedMyCommentTableViewReactor.Mutation> in
            return error.toMutation()
          },
        .just(.isReloading(false)),
      ])
      
    case .scrollToNextPage:
      let lastCommentId = Int64(currentState.comments.last?.commentId ?? Int.max)
      return .concat([
        .just(.setTableState),
        .just(.setIsFetchingPage(true)),
        getMyCommentsUseCase.execute(lastCommentId: lastCommentId, size: 10)
          .map { .setNextPage(comments: $0) }
          .catch { error -> Observable<FeedMyCommentTableViewReactor.Mutation> in
            return error.toMutation()
          },
        .just(.setIsFetchingPage(false))
      ])
      
    case .favorite(let commentId, let changedState):
      if let index = currentState.comments.firstIndex(where: { $0.commentId == commentId }),
         currentState.comments[index].like == changedState {
        return .concat([])
      } else {
        return setCommentLikeUseCase.execute(changedState: changedState, commentId: commentId)
          .map { [changedState] commentId in
            return .setLike(commentId: commentId, changedState: changedState)
          }
      }
      
    default:
      return .concat([])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case .setList(let comments):
      newState.comments = comments
      
      if comments.isEmpty {
        newState.tableState = .loadedEmpty
      } else if comments.count < 10 {
        newState.tableState = .loadedLastPage
      } else {
        newState.tableState = .loaded
      }
      
    case .setListRefresh(let comments):
      newState.comments = comments
      
      if comments.isEmpty {
        newState.tableState = .loadedEmpty
      } else if comments.count < 10 {
        newState.tableState = .loadedLastPage
      }  else {
        newState.tableState = .loaded
      }
    
    case .setNextPage(let comments):
      newState.comments += comments
      
      if comments.count < 10 {
        newState.tableState = .lastPage
      } else {
        newState.tableState = .paged(addedCount: comments.count)
      }
      
    case .setLike(let commentId, let changedState):
      if let index = newState.comments.firstIndex(where: { $0.commentId == commentId }) {
        let likeCount = newState.comments[index].likeCount

        newState.comments[index].like = changedState
        newState.comments[index].likeCount = changedState ? likeCount + 1 : likeCount - 1
      }
      
    case .setTableState:
      newState.tableState = nil
      
    case .setIsFetchingPage(let bool):
      newState.isFetchingPage = bool
    case .isReloading(let bool):
      newState.isReloading = bool
    case .setIsLoading(let bool):
      newState.isLoading = bool
    case .setError(let error):
      newState.errorState = error
    }
    
    return newState
  }
}

extension Error {
  func toMutation() -> Observable<FeedMyCommentTableViewReactor.Mutation> {
    let errorMutation: Observable<FeedMyCommentTableViewReactor.Mutation> = {
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
