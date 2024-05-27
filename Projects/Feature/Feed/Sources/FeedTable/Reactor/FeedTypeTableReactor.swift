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
import SharedUtil

final class FeedTypeTableReactor: Reactor {
  private let getFeedsPageUseCase: GetFeedsPageUseCase
  private let setBookmarkAndLikeUseCase: SetBookmarkAndLikeUseCase
  private let reportUseCase: ReportUseCase

  enum Action {
    case viewDidLoad
    case refresh
    case refreshSuccessWrited(postId: Int)
    case scrollToNextPage
    
    case showDetail(postId: Int)
    
    case reportBlockUser(userId: Int)
    case reportPost(postId: Int)
    
    case bookmark(postId: Int, changedState: Bool)
    case favorite(postId: Int, changedState: Bool)
  }
  
  enum Mutation {
    case setList([Feed])
    case setListRefresh([Feed])
    case setNextPage(feeds: [Feed])
    case setTableState
    
    case setLike(postId: Int, changedState: Bool)
    case setBookmark(postId: Int, changedState: Bool)
    
    case setBlockedId(userId: Int?)
    case setReportedId(postId: Int?)
    
    case setIsFetchingPage(Bool)
    case isReloading(Bool)
    case setIsLoading(Bool)
    case setError(ErrorType?)
  }
  
  struct State {
    let feedType: FeedPageType
    
    var feeds: [Feed] = []
    
    var tableState: FeedTableState? = nil
    var isFetchingPage: Bool = false
    
    var blockedIndexs: [Int]? = nil
    var reportedIdIndex: Int? = nil

    var isReloading: Bool = false
    var isLoading: Bool = false
    var errorState: ErrorType? = nil
  }
  
  var newPageIndexPath: [IndexPath] {
    guard let tableState = currentState.tableState else { return [] }
    
    switch tableState {
    case .paged(let addedCount):
      var indexPaths: [IndexPath] = []
      let lastRowIndex: Int = currentState.feeds.count - addedCount
      for count in 0..<addedCount {
        indexPaths.append(IndexPath(row: lastRowIndex + count, section: 0))
      }
      return indexPaths
    default:
      return []
    }
  }
  
  
  var initialState: State
  
  init(getFeedsPageUseCase: GetFeedsPageUseCase, setBookmarkAndLikeUseCase: SetBookmarkAndLikeUseCase, reportUseCase: ReportUseCase, feedType: FeedPageType) {
    self.getFeedsPageUseCase = getFeedsPageUseCase
    self.setBookmarkAndLikeUseCase = setBookmarkAndLikeUseCase
    self.reportUseCase = reportUseCase
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
        .just(.setTableState),
        .just(.setIsLoading(true)),
        getFeedsPageUseCase.execute(feedType: initialState.feedType, lastPostId: Int.max, size: 11)
          .map { .setList($0) }
          .catch { error -> Observable<FeedTypeTableReactor.Mutation> in
            return error.toMutation()
          },
        .just(.setIsLoading(false)),
      ])
    case .refresh:
      return .concat([
        .just(.setTableState),
        .just(.isReloading(true)),
        getFeedsPageUseCase.execute(feedType: initialState.feedType, lastPostId: Int.max, size: 11)
          .map { .setListRefresh($0) }
          .catch { error -> Observable<FeedTypeTableReactor.Mutation> in
            return error.toMutation()
          },
        .just(.isReloading(false)),
      ])
    case .refreshSuccessWrited(let postId):
      return .concat([
        .just(.setTableState),
        .just(.setIsLoading(true)),
        getFeedsPageUseCase.execute(feedType: initialState.feedType, lastPostId: postId, size: 11)
          .map { .setListRefresh($0) }
          .catch { error -> Observable<FeedTypeTableReactor.Mutation> in
            return error.toMutation()
          },
        .just(.setIsLoading(false))
       
      ])
    case .scrollToNextPage:
      let lastPostId = currentState.feeds.last?.postId ?? Int.max
      return .concat([
        .just(.setTableState),
        .just(.setIsFetchingPage(true)),
        getFeedsPageUseCase.execute(feedType: initialState.feedType, lastPostId: lastPostId, size: 11)
          .map { .setNextPage(feeds: $0) }
          .catch { error -> Observable<FeedTypeTableReactor.Mutation> in
            return error.toMutation()
          },
        .just(.setIsFetchingPage(false))
      ])
      


    case .showDetail(postId: let postId):
      return .concat([])
  
    case .bookmark(let postId, let changedState):
      if let index = currentState.feeds.firstIndex(where: { $0.postId == postId }),
         currentState.feeds[index].bookmark == changedState {
        return .just(.setIsLoading(false))
      } else {
        return setBookmarkAndLikeUseCase.executeBookmark(changedState: changedState, postId: postId)
          .map { [changedState] postId in
            return .setBookmark(postId: postId, changedState: changedState)
          }
      }
          
    
    case .favorite(let postId, let changedState):
      if let index = currentState.feeds.firstIndex(where: { $0.postId == postId }),
         currentState.feeds[index].like == changedState {
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
      return .concat([])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    
    var newState = state
    switch mutation {
    case .setList(let feeds):
      newState.feeds = feeds
      
      if feeds.isEmpty {
        newState.tableState = .loadedEmpty
      } else if feeds.count < 11 {
        newState.tableState = .loadedLastPage
      } else {
        newState.tableState = .loaded
      }
      
    case .setListRefresh(let feeds):
      newState.feeds = feeds
      
      if feeds.isEmpty {
        newState.tableState = .loadedEmpty
      } else if feeds.count < 11 {
        newState.tableState = .loadedLastPage
      }  else {
        newState.tableState = .loaded
      }
    
    case .setNextPage(feeds: let feeds):
      newState.feeds += feeds
      
      if feeds.count < 11 {
        newState.tableState = .lastPage
      } else {
        newState.tableState = .paged(addedCount: feeds.count)
      }
      
    case .setTableState:
      newState.tableState = nil
      
    case .setLike(let postId, let editedState):
      if let index = newState.feeds.firstIndex(where: { $0.postId == postId }) {
        newState.feeds[index].like = editedState
        let likeCount = newState.feeds[index].likeCount
        newState.feeds[index].likeCount = editedState ? likeCount + 1 : likeCount - 1
      }
    case .setBookmark(let postId, let editedState):
      if let index = newState.feeds.firstIndex(where: { $0.postId == postId }) {
        newState.feeds[index].bookmark = editedState
      }

    case .setIsFetchingPage(let bool):
      newState.isFetchingPage = bool
    case .setIsLoading(let bool):
      newState.isLoading = bool
    case .setError(let errorType):
      newState.errorState = errorType
    case .isReloading(let bool):
      newState.isReloading = bool
   
    case .setBlockedId(userId: let userId):
      var indexs = [Int]()
      for (idx, item) in newState.feeds.enumerated() {
        if item.userId == userId {
          indexs.append(idx)
        }
      }
      for index in indexs {
        newState.feeds.remove(at: index)
      }
      
      newState.blockedIndexs = indexs
    case .setReportedId(postId: let postId):
      if let index = newState.feeds.firstIndex(where: { $0.postId == postId }) {
        newState.feeds.remove(at: index)
        newState.reportedIdIndex = postId
      }
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
