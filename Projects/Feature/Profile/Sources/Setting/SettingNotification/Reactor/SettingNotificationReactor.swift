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
  private let getNotificationCheckedData: GetNotificationCheckedData
  private let saveNotificationBoolean: SaveNotificationBoolean
  
  enum Action {
    case viewDidLoad
    case toggleMarketingNoti(Bool)
    case toggleChattingNoti(Bool)
    case toggleFeedNoti(Bool)
  }
  
  enum Mutation {
    case setAllState(NotificationReceiveCheck)
    case setNotificationState(type: NotificationType)
    case setIsLoadind(Bool)
    case setError(ErrorType?)
  }
  
  struct State {
    var state: NotificationReceiveCheck = .init(marketingNotification: true, chattingNotification: true, feedNotification: true)
    
    var errorType: ErrorType? = nil
    var isLoading: Bool = false
  }
  
  var initialState: State
  
  public init(getNotificationCheckedData: GetNotificationCheckedData, saveNotificationBoolean: SaveNotificationBoolean) {
    self.getNotificationCheckedData = getNotificationCheckedData
    self.saveNotificationBoolean = saveNotificationBoolean
    self.initialState = State()
  }
  
  public enum ErrorType: Error {
    case unknownError
  }
}

extension SettingNotificationReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return .concat([
        .just(.setIsLoadind(false)),
        getNotificationCheckedData.execute()
          .map { state in .setAllState(state) }
          .catch { error -> Observable<Mutation> in
            return error.toMutation()
          },
        .just(.setIsLoadind(true))
      ])
    case .toggleChattingNoti(let bool):
      return saveNotificationBoolean.execute(type: .chatting, agree: bool)
        .map { _ in .setNotificationState(type: .chat)}
        .catch { error -> Observable<Mutation> in
          return error.toMutation()
        }
    case .toggleFeedNoti(let bool):
      return saveNotificationBoolean.execute(type: .feed, agree: bool)
        .map { _ in .setNotificationState(type: .feed)}
        .catch { error -> Observable<Mutation> in
          return error.toMutation()
        }
    case .toggleMarketingNoti(let bool):
      return saveNotificationBoolean.execute(type: .marketing, agree: bool)
        .map { _ in .setNotificationState(type: .marketing)}
        .catch { error -> Observable<Mutation> in
          return error.toMutation()
        }
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setAllState(let state):
      newState.state = state
    case .setError(let error):
      newState.errorType = error
    case .setIsLoadind(let bool):
      newState.isLoading = bool
    case .setNotificationState(type: let type):
      newState.errorType = nil
    }
    
    return newState
  }
}

extension Error {
  func toMutation() -> Observable<SettingNotificationReactor.Mutation> {
    let errorMutation: Observable<SettingNotificationReactor.Mutation> = {
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


