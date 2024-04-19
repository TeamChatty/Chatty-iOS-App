//
//  FeedMainReactor.swift
//  FeatureFeedInterface
//
//  Created by 윤지호 on 4/15/24.
//


import ReactorKit
import DomainUser
import DomainUserInterface
import DomainCommunityInterface
import DomainCommon

final class FeedMainReactor: Reactor {

  
  enum Action {
    case changePage(Int)
  }
  
  enum Mutation {
    case setPage(Int)
    case setIsLoading(Bool)
    case setError(ErrorType?)
  }
  
  struct State {
    var isLoading: Bool = false
    var pageIndex: Int = 0
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

extension FeedMainReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .changePage(let index):
      return .just(.setPage(index))
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
    }
    return newState
  }
}

extension Error {
  func toMutation() -> Observable<FeedMainReactor.Mutation> {
    let errorMutation: Observable<FeedMainReactor.Mutation> = {
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


