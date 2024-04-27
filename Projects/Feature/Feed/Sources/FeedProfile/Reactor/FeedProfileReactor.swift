//
//  FeedProfileReactor.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/26/24.
//


import ReactorKit
import DomainUser
import DomainUserInterface
import DomainCommunityInterface
import DomainCommon

final class FeedProfileReactor: Reactor {
  enum Action {
    case changePage(Int)
    case feedWrited
  }
  
  enum Mutation {
    case setPage(Int)
    case refreshWritedFeedList(Bool)
    case setIsLoading(Bool)
    case setError(ErrorType?)
  }
  
  struct State {
    var isLoading: Bool = false
    var pageIndex: Int = 0
    var isWrited: Bool = false
    var errorState: ErrorType? = nil
  }
  
  var initialState: State
  
  init() {
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

extension FeedProfileReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .changePage(let index):
      return .just(.setPage(index))
    case .feedWrited:
      return .concat([
        .just(.refreshWritedFeedList(true)),
        .just(.refreshWritedFeedList(false))
      ])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setPage(let index):
      newState.pageIndex = index
    case .setIsLoading(let bool):
      newState.isLoading = bool
    case .setError(let errorType):
      newState.errorState = errorType
    case .refreshWritedFeedList(let bool):
      newState.isWrited = bool
    }
    return newState
  }
}

extension Error {
  func toMutation() -> Observable<FeedProfileReactor.Mutation> {
    let errorMutation: Observable<FeedProfileReactor.Mutation> = {
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
