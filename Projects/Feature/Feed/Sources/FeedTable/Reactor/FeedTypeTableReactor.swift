//
//  FeedTypeTableReactor.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/19/24.
//

import Foundation
import ReactorKit
import DomainCommunityInterface
import DomainCommon

final class FeedTypeTableReactor: Reactor {
  private let getFeedsPageUseCase: GetFeedsPageUseCase

  enum Action {
    case viewDidLoad
    case refresh
    case scrollToNextPage
    
    case showDetail(postId: Int)
    case report(userId: Int)
    case bookmark(postId: Int)
    case favorite(postId: Int)
  }
  
  enum Mutation {
    case setList([Feed])
    case setListRefresh([Feed])
    case setNextPage(feeds: [Feed])
    
    case setIsFetchingPage(Bool)
    case isReloading(Bool)
    case setIsLoading(Bool)
    case setError(ErrorType?)
  }
  
  struct State {
    let feedType: FeedListType
    
    var feeds: [Feed] = []
    var newPageItemCount: Int? = nil
    
    var isLastPage: Bool = false
    var isFetchingPage: Bool = false
    var isReloading: Bool = false
    var isLoading: Bool = false
    var errorState: ErrorType? = nil
  }
  
  var newPageIndexPath: [IndexPath] {
    guard let newPageItemCount = currentState.newPageItemCount else {
      return []
    }
    var indexPaths: [IndexPath] = []
    let lastRowIndex: Int = currentState.feeds.count - newPageItemCount
    for count in 0..<newPageItemCount {
      indexPaths.append(IndexPath(row: lastRowIndex + count, section: 0))
    }
    return indexPaths
  }
  
  
  var initialState: State
  
  init(getFeedsPageUseCase: GetFeedsPageUseCase, feedType: FeedListType) {
    self.getFeedsPageUseCase = getFeedsPageUseCase
    self.initialState = State(
      feedType: feedType
    )
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

extension FeedTypeTableReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return .concat([
        .just(.setIsLoading(true)),
        getFeedsPageUseCase.execute(lastPostId: Int.max, size: 10)
          .map { .setList($0) }
          .catch { error -> Observable<FeedTypeTableReactor.Mutation> in
            return error.toMutation()
          },
        .just(.setIsLoading(false))
      ])
    case .refresh:
      return .concat([
        .just(.isReloading(true)),
        getFeedsPageUseCase.execute(lastPostId: Int.max, size: 10)
          .map { .setListRefresh($0) }
          .catch { error -> Observable<FeedTypeTableReactor.Mutation> in
            return error.toMutation()
          },
        .just(.isReloading(false))
      ])
    case .scrollToNextPage:
      if currentState.isFetchingPage {
        return .just(.setIsLoading(false))
      } else {
        let lastPostId = currentState.feeds.last?.postId ?? Int.max
        return .concat([
          .just(.setIsFetchingPage(true)),
          getFeedsPageUseCase.execute(lastPostId: lastPostId, size: 10)
            .map { .setNextPage(feeds: $0) }
            .catch { error -> Observable<FeedTypeTableReactor.Mutation> in
              return error.toMutation()
            },
          .just(.setIsFetchingPage(false))
        ])
      }


    case .showDetail(postId: let postId):
      return .concat([])
    case .report(userId: let userId):
      return .concat([])
    case .bookmark(postId: let postId):
      return .concat([])
    case .favorite(postId: let postId):
      return .concat([])

    
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    
    var newState = state
    switch mutation {
    case .setList(let feeds):
      newState.feeds = feeds
      newState.newPageItemCount = 0
      newState.isLastPage = false

    case .setListRefresh(let feeds):
      newState.feeds = feeds
      newState.newPageItemCount = -1
      newState.isLastPage = false

      print("refresh")
    case .setNextPage(feeds: let feeds):
      print("1. newState.feeds => \(newState.feeds.count)")
      newState.feeds += feeds
      newState.newPageItemCount = feeds.count
      if feeds.isEmpty {
        newState.isLastPage = true
        print("isLastPage")
      }

    case .setIsFetchingPage(let bool):
      newState.isFetchingPage = bool
      newState.newPageItemCount = nil
    case .setIsLoading(let bool):
      newState.isLoading = bool
    case .setError(let errorType):
      newState.errorState = errorType
    case .isReloading(let bool):
      newState.isReloading = bool
   
    
    }
    return newState
  }
}

extension Error {
  func toMutation() -> Observable<FeedTypeTableReactor.Mutation> {
    let errorMutation: Observable<FeedTypeTableReactor.Mutation> = {
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


