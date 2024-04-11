//
//  SettingReactor.swift
//  FeatureProfileInterface
//
//  Created by 윤지호 on 4/11/24.
//


import UIKit
import ReactorKit
import DomainUser
import DomainUserInterface
import DomainCommon

final class SettingReactor: Reactor {
  enum Action {
    case tabLogoutAlertButton
  }
  
  enum Mutation {
    case setLogout
  }
  
  struct State {
    var isLogout = false
  }
  
  var initialState: State
  
  public init() {
    self.initialState = State()
  }
  
  public enum ErrorType: Error {
    case unknownError
  }
}

extension SettingReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tabLogoutAlertButton:
      return .just(.setLogout)
    }
  }
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setLogout:
      newState.isLogout = true
    }
    
    return newState
  }
}

//extension Error {
//  func toMutation() -> Observable<SettingReactor.Mutation> {
//    let errorMutation: Observable<SettingReactor.Mutation> = {
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


