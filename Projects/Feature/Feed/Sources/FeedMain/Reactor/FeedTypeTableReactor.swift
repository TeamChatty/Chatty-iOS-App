//
//  FeedTypeTableReactor.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/19/24.
//

import ReactorKit
import DomainCommunityInterface
import DomainCommon


enum FeedType {
  case lastest
  case recommend
}

final class FeedTypeTableReactor: Reactor {

  
  enum Action {
    case showDetail(postId: Int)
    case report(userId: Int)
    case bookmark(postId: Int)
    case favorite(postId: Int)
  }
  
  enum Mutation {
    case setIsLoading(Bool)
    case setError(ErrorType?)
  }
  
  struct State {
    let feedType: FeedType
    
    var feeds: [Feed] = []
    
    var isLoading: Bool = false
    var errorState: ErrorType? = nil
  }
  
  var initialState: State
  
  init(feedType: FeedType) {
    self.initialState = State(
      feedType: feedType,
      feeds: [
        Feed(postId: 0, title: "0", content: "11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "0", imageUrl: "2323"),
        Feed(postId: 1, title: "1", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "1", imageUrl: "2323"),
        Feed(postId: 2, title: "2", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "2", imageUrl: "2323"),
        Feed(postId: 0, title: "0", content: "11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "0", imageUrl: "2323"),
        Feed(postId: 1, title: "1", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "1", imageUrl: "2323"),
        Feed(postId: 2, title: "2", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "2", imageUrl: "2323"),
        Feed(postId: 0, title: "0", content: "11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "0", imageUrl: "2323"),
        Feed(postId: 1, title: "1", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "1", imageUrl: "2323"),
        Feed(postId: 2, title: "2", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "2", imageUrl: "2323"),
        Feed(postId: 0, title: "0", content: "11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "0", imageUrl: "2323"),
        Feed(postId: 1, title: "1", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "1", imageUrl: "2323"),
        Feed(postId: 2, title: "2", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "2", imageUrl: "2323"),
        Feed(postId: 0, title: "0", content: "11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "0", imageUrl: "2323"),
        Feed(postId: 1, title: "1", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "1", imageUrl: "2323"),
        Feed(postId: 2, title: "2", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "2", imageUrl: "2323"),
        Feed(postId: 0, title: "0", content: "11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "0", imageUrl: "2323"),
        Feed(postId: 1, title: "1", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "1", imageUrl: "2323"),
        Feed(postId: 2, title: "2", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "2", imageUrl: "2323"),
        Feed(postId: 0, title: "0", content: "11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "0", imageUrl: "2323"),
        Feed(postId: 1, title: "1", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "1", imageUrl: "2323"),
        Feed(postId: 2, title: "2", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "2", imageUrl: "2323"),
        Feed(postId: 0, title: "0", content: "11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "0", imageUrl: "2323"),
        Feed(postId: 1, title: "1", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "1", imageUrl: "2323"),
        Feed(postId: 2, title: "2", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "2", imageUrl: "2323"),
        Feed(postId: 0, title: "0", content: "11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "0", imageUrl: "2323"),
        Feed(postId: 1, title: "1", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "1", imageUrl: "2323"),
        Feed(postId: 2, title: "2", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "2", imageUrl: "2323"),
        Feed(postId: 0, title: "0", content: "11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa11adadawdwa", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "0", imageUrl: "2323"),
        Feed(postId: 1, title: "1", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "1", imageUrl: "2323"),
        Feed(postId: 2, title: "2", content: "1egaewgewgeg1", viewCount: 2, createdAt: "2024-04-17T00:08:31.268Z", userId: 29, nickname: "2", imageUrl: "2323"),
      ]
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
//  func mutate(action: Action) -> Observable<Mutation> {
//
//  }
//  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setIsLoading(let bool):
      newState.isLoading = bool
    case .setError(let errorType):
      newState.errorState = errorType
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


