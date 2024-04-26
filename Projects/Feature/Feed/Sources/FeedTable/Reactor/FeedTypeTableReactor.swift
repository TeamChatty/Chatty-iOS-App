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
    
    case isReloading(Bool)
    case setIsLoading(Bool)
    case setError(ErrorType?)
  }
  
  struct State {
    let feedType: FeedListType
    
    var feeds: [Feed] = []
    var newPageItemCount: Int? = nil
    
    var isReloading: Bool = false
    var isLoading: Bool = false
    var errorState: ErrorType? = nil
  }
  
  var newPageIndexPath: [IndexPath] {
    guard let newPageItemCount = currentState.newPageItemCount else { return [] }
    var indexPaths: [IndexPath] = []
    let lastRowIndex: Int = currentState.feeds.count
    for count in 0..<newPageItemCount {
      indexPaths.append(IndexPath(row: lastRowIndex + count, section: 0))
    }
    return indexPaths
  }
  
  
  var initialState: State
  
  init(feedType: FeedListType) {
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
        .just(.setList([
//          Feed(postId: 0, title: "무우무우", content: "성시경 콘서트 다녀왔어요", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "무우무우", imageUrl: "2323"),
//          Feed(postId: 1, title: "메인", content: "축구 이야기 하실분~", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "메인", imageUrl: "2323"),
//          Feed(postId: 2, title: "2", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "2", imageUrl: "2323"),
        ])),
        .just(.setIsLoading(false))
      ])
    case .refresh:
      return .concat([
        .just(.isReloading(true)),
        .just(.setListRefresh([
          Feed(postId: 2, title: "2", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "2", imageUrl: "2323"),
          Feed(postId: 2, title: "2", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "2", imageUrl: "2323"),
          Feed(postId: 2, title: "2", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "2", imageUrl: "2323"),
          Feed(postId: 2, title: "2", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "2", imageUrl: "2323"),
          Feed(postId: 0, title: "0", content: "11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "0", imageUrl: "2323"),
          Feed(postId: 1, title: "1", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "1", imageUrl: "2323"),
          Feed(postId: 2, title: "2", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "2", imageUrl: "2323"),
        ])),
        .just(.isReloading(false))
      ])
    case .scrollToNextPage:
      return .concat([
        .just(.setListRefresh([
          Feed(postId: 0, title: "0", content: "11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "0", imageUrl: "2323"),
          Feed(postId: 1, title: "1", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "1", imageUrl: "2323"),
          Feed(postId: 2, title: "2", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "2", imageUrl: "2323"),
        ]))
      ])

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

    case .setListRefresh(let feeds):
      newState.feeds = feeds
      newState.newPageItemCount = -1

      print("refresh")
    case .setNextPage(feeds: let feeds):
      newState.feeds += feeds
      newState.newPageItemCount = feeds.count
      print("nextPage")
      
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


