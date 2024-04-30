//
//  SettingLeaveAccountReactor.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/11/24.
//


import UIKit
import ReactorKit
import DomainUser
import DomainUserInterface
import DomainCommon

final class SettingLeaveAccountReactor: Reactor {
  private let leaveAccountUseCase: LeaveAccountUseCase
  
  enum Action {
    case TabremoveAccount
  }
  
  enum Mutation {
    case removeAccount
    case setIsLoading(Bool)
    case setError(ErrorType?)
  }
  
  struct State {
    var isSuccessRemove: Bool = false
    var isLoading: Bool = false
    var errorState: ErrorType? = nil
  }
  
  var initialState: State
  
  public init(leaveAccountUseCase: LeaveAccountUseCase) {
    self.leaveAccountUseCase = leaveAccountUseCase
    self.initialState = State()
  }
  
  public enum ErrorType: Error {
    case unknownError
  }
}

extension SettingLeaveAccountReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .TabremoveAccount:
      return .concat([
        .just(.setIsLoading(true)),
        leaveAccountUseCase.execute()
          .map { _ in .removeAccount }
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
    case .removeAccount:
      newState.isSuccessRemove = true
    case .setIsLoading(let bool):
      newState.isLoading = bool
    case .setError(let error):
      newState.errorState = error
    }
    
    return newState
  }
}

extension Error {
  func toMutation() -> Observable<SettingLeaveAccountReactor.Mutation> {
    let errorMutation: Observable<SettingLeaveAccountReactor.Mutation> = {
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


