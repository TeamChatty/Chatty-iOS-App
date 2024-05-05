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
  private let logoutUseCase: LogoutUseCase
  
  enum Action {
    case tabLogoutAlertButton
  }
  
  enum Mutation {
    case setLogout(Bool)
    case setError(ErrorType?)
    case setIsLoading(Bool)
  }
  
  struct State {
    var isLogout: Bool = false
    
    var isLoading: Bool = false
    var errorType: ErrorType? = nil
  }
  
  var initialState: State
  
  public init(logoutUseCase: LogoutUseCase) {
    self.logoutUseCase = logoutUseCase
    self.initialState = State()
  }
  
  public enum ErrorType: Error {
    case unknownError
    case logoutFalse
  }
}

extension SettingReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tabLogoutAlertButton:
      return .concat([
        .just(.setIsLoading(true)),
        logoutUseCase.execute()
          .map { _ -> Mutation in
            return .setLogout(true)
          }
          .catch { error -> Observable<Mutation> in
            return error.toMutation()
          },
        .just(.setIsLoading(false))
      ])
    }
  }
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setLogout:
      newState.isLogout = true
    case .setError(let error):
      newState.errorType = error
    case .setIsLoading(let isLoading):
      newState.isLoading = isLoading
    }
    
    return newState
  }
}

extension Error {
  func toMutation() -> Observable<SettingReactor.Mutation> {
    let errorMutation: Observable<SettingReactor.Mutation> = {
      guard let error = self as? NetworkError else {
        return .just(.setError(.unknownError))
      }
      switch error.errorCase {
      default:
        return .just(.setError(.unknownError))
      }
    }()
    
    return Observable.concat([
      errorMutation,
      .just(.setError(nil))
    ])
  }
}


