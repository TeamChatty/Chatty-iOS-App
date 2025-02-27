//
//  ProfileEditIntroduceReactor.swift
//  FeatureOnboarding
//
//  Created by 윤지호 on 4/4/24.
//

import ReactorKit
import DomainUser
import DomainUserInterface
import DomainCommon

final class ProfileEditIntroduceReactor: Reactor {
  private let getUserDataUseCase: GetUserProfileUseCase
  private let saveIntroduceUseCase: SaveIntroduceUseCase
  
  enum Action {
    case inputText(String)
    case tabChangeButton
  }
  
  enum Mutation {
    case setInputText(String)

    case isLoading(Bool)
    case setIsChangeButtonEnabled(Bool)
    case setIsSaveSuccess
    case setError(ErrorType?)
  }
  
  struct State {
    var profileData: UserProfile
    
    var inputedNicknameText: String = ""
    
    var isLoading: Bool = false
    var isChangeButtonEnabled = false
    var isSaveSuccess: Bool = false
    var errorState: ErrorType? = nil
  }
  
  var initialState: State
  
  public init(saveIntroduceUseCase: SaveIntroduceUseCase, getUserDataUseCase: GetUserProfileUseCase) {
    self.getUserDataUseCase = getUserDataUseCase
    self.saveIntroduceUseCase = saveIntroduceUseCase
    self.initialState = State(profileData: getUserDataUseCase.execute())
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

extension ProfileEditIntroduceReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tabChangeButton:
      return .concat([
        .just(.isLoading(true)),
        self.saveIntroduceUseCase.execute(introduce: self.currentState.inputedNicknameText)
          .asObservable()
          .map { _ in .setIsSaveSuccess }
          .catch { error -> Observable<Mutation> in
            return error.toMutation()
          },
        .just(.isLoading(false))
      ])
      
    case .inputText(let text):
      var isChangeButtonEnabled: Bool = false
      if text.count < 10 || text.isEmpty {
        isChangeButtonEnabled = false
      } else {
        isChangeButtonEnabled = true
      }
      return .concat([
        .just(.setInputText(text)),
        .just(.setIsChangeButtonEnabled(isChangeButtonEnabled))
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
      
    case .setInputText(let text):
      newState.inputedNicknameText = text
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
  func toMutation() -> Observable<ProfileEditIntroduceReactor.Mutation> {
    let errorMutation: Observable<ProfileEditIntroduceReactor.Mutation> = {
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
