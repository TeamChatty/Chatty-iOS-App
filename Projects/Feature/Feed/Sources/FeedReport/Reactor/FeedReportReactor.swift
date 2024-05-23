//
//  FeedReportReactor.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/4/24.
//

import ReactorKit
import SharedDesignSystem
import DomainUser
import DomainUserInterface
import DomainCommon

final class FeedReportReactor: Reactor {
  
  enum Action {
    case selectCase(ReportCase)
    case tabChangeButton
  }
  
  enum Mutation {
    case setSelectedCase(ReportCase)

    case isLoading(Bool)
    case setIsChangeButtonEnabled(Bool)
    case setIsSaveSuccess
    case setError(ErrorType?)
  }
  
  struct State {
    let userId: Int
    let addressArray: [RadioSegmentItem]
    var selectedAddress: ReportCase?
    
    var isLoading: Bool = false
    var isChangeButtonEnabled = false
    var isSaveSuccess: Bool = false
    var errorState: ErrorType? = nil
  }
  
  var initialState: State
  
  public init(userId: Int) {
    self.initialState = State(
      userId: userId,
      addressArray: ReportCase.allCases.enumerated().map { index, name in
        return RadioSegmentItem(id: index, title: name.stringKR)
      }
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

extension FeedReportReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tabChangeButton:
      return .concat([
        .just(.isLoading(true)),
       
        .just(.isLoading(false))
      ])
      
    case .selectCase(let reportCase):
      return .concat([
        .just(.setSelectedCase(reportCase)),
        .just(.setIsChangeButtonEnabled(true))
      ])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .isLoading(let bool):
      newState.isLoading = bool
    case .setIsSaveSuccess:
      newState.isSaveSuccess = true
    case .setSelectedCase(let address):
      newState.selectedAddress = address
      if newState.errorState != nil {
        newState.errorState = nil
      }
    case .setIsChangeButtonEnabled(let bool):
      newState.isChangeButtonEnabled = bool
    case .setError(let error):
      newState.errorState = error
    }
    return newState
  }
}

extension Error {
  func toMutation() -> Observable<FeedReportReactor.Mutation> {
    let errorMutation: Observable<FeedReportReactor.Mutation> = {
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
