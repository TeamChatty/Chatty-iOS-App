//
//  SettingReactor.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/11/24.
//


import UIKit
import ReactorKit
import DomainUser
import DomainUserInterface
import DomainCommon

final class SettingNotificationReactor: Reactor {
  enum Action {
    case toggleMarketingNoti(Bool)
    case toggleChattingNoti(Bool)
    case toggleFeedNoti(Bool)
  }
  
  enum Mutation {
   
  }
  
  struct State {
    
  }
  
  var initialState: State
  
  public init() {
    self.initialState = State()
  }
  
  public enum ErrorType: Error {
    case unknownError
  }
}

//extension SettingNotificationReactor {
//  func mutate(action: Action) -> Observable<Mutation> {
//
//  
//  func reduce(state: State, mutation: Mutation) -> State {
//    var newState = state
//    
//    
//    return newState
//  }
//}

//extension Error {
//  func toMutation() -> Observable<SettingNotificationReactor.Mutation> {
//    let errorMutation: Observable<SettingNotificationReactor.Mutation> = {
//      guard let error = self as? NetworkError else {
//        return .just(.setError(.unknownError))
//      }
//      switch error.errorCase {
//      default:
//        return .just(.setError(.unknownError))
//      }
//    }()
//    
//    return Observable.concat([
//      errorMutation,
//      .just(.setError(nil))
//    ])
//  }
//}


