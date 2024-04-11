//
//  ProfileEditMBTIReactor.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/5/24.
//

import ReactorKit
import DomainUser
import DomainUserInterface
import DomainCommon


final class ProfileEditMBTIReactor: Reactor {
  private let getUserDataUseCase: GetUserDataUseCase
  private let saveMBTIUseCase: SaveMBTIUseCase
  
  enum Action {
    case tabChangeButton
    case toggleMBTI(MBTISeletedState, Bool)
  }
  
  enum Mutation {
    case toggleMBTI(MBTISeletedState, Bool)

    case isLoading(Bool)
    case setIsChangeButtonEnabled(Bool)
    case setIsSaveSuccess
    case setError(ErrorType?)
  }
  
  struct State {
    var mbti: MBTI = .init()
    
    var isLoading: Bool = false
    var isChangeButtonEnabled = false
    var isSaveSuccess: Bool = false
    var errorState: ErrorType? = nil
  }
  
  var initialState: State = .init()
  
  public init(saveMBTIUseCase: SaveMBTIUseCase, getUserDataUseCase: GetUserDataUseCase) {
    self.getUserDataUseCase = getUserDataUseCase
    self.saveMBTIUseCase = saveMBTIUseCase
    if let mbti: String = getUserDataUseCase.execute().mbti {
      self.initialState = State(mbti: .init(mbti: mbti))
    } else {
      self.initialState =  State()
    }
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

extension ProfileEditMBTIReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .toggleMBTI(let mbti, let state):
      return .just(.toggleMBTI(mbti, state))
    case .tabChangeButton:
      return .concat([
        .just(.isLoading(true)),
        self.saveMBTIUseCase.execute(mbti: currentState.mbti.requestString)
          .asObservable()
          .map { _ in .setIsSaveSuccess }
          .catch { error -> Observable<Mutation> in
            return error.toMutation()
          },
        .just(.isLoading(false))
      ])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    
    var newState = state
    switch mutation {
    case .toggleMBTI(let mbti, let state):
      newState.mbti.setMBTI(mbti: mbti, state: state)
      newState.isChangeButtonEnabled = newState.mbti.didSeletedAll
    case .isLoading(let bool):
      newState.isLoading = bool
    case .setIsSaveSuccess:
      newState.isSaveSuccess = true
    case .setIsChangeButtonEnabled(let bool):
      newState.isChangeButtonEnabled = bool
    case .setError(let error):
      newState.errorState = error
    }
    return newState
  }
}

extension Error {
  func toMutation() -> Observable<ProfileEditMBTIReactor.Mutation> {
    let errorMutation: Observable<ProfileEditMBTIReactor.Mutation> = {
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
