//
//  ProfileEditJobReactor.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/5/24.
//

import ReactorKit
import DomainUser
import DomainUserInterface
import DomainCommon

final class ProfileEditJobAndSchoolReactor: Reactor {
  private let getUserDataUseCase: GetUserDataUseCase
  private let saveSchoolUserCase: SaveSchoolUseCase
  private let saveJobUseCase: SaveJobUseCase
  
  enum Action {
    case inputNickname(String)
    case tabChangeButton
  }
  
  enum Mutation {
    case inputNickname(String)

    case isLoading(Bool)
    case setIsChangeButtonEnabled(Bool)
    case setIsSaveSuccess
    case setError(ErrorType?)
  }
  
  struct State {
    let profileEditType: ProfileEditType
    var profileData: UserProfile
    
    var inputedText: String = ""
    
    var isLoading: Bool = false
    var isChangeButtonEnabled = false
    var isSaveSuccess: Bool = false
    var errorState: ErrorType? = nil
  }
  
  var initialState: State
  
  init(editType: ProfileEditType, getUserDataUseCase: GetUserDataUseCase,
       saveSchoolUserCase: SaveSchoolUseCase,
       saveJobUseCase: SaveJobUseCase) {
    self.getUserDataUseCase = getUserDataUseCase
    self.saveSchoolUserCase = saveSchoolUserCase
    self.saveJobUseCase = saveJobUseCase
    self.initialState = State(
      profileEditType: editType,
      profileData: getUserDataUseCase.execute()
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

extension ProfileEditJobAndSchoolReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tabChangeButton:
      switch currentState.profileEditType {
      case .job:
        return .concat([
          .just(.isLoading(true)),
          self.saveJobUseCase.execute(job: self.currentState.inputedText)
            .asObservable()
            .map { _ in .setIsSaveSuccess }
            .catch { error -> Observable<Mutation> in
              return error.toMutation()
            },
          .just(.isLoading(false))
        ])
      case .school:
        return .concat([
          .just(.isLoading(true)),
          self.saveSchoolUserCase.execute(school: self.currentState.inputedText)
            .asObservable()
            .map { _ in .setIsSaveSuccess }
            .catch { error -> Observable<Mutation> in
              return error.toMutation()
            },
          .just(.isLoading(false))
        ])
      default:
        return .just(.isLoading(false))
      }
      
    case .inputNickname(let text):
      var isChangeButtonEnabled: Bool = false
      if text.isEmpty {
        isChangeButtonEnabled = false
      } else {
        isChangeButtonEnabled = true
      }
      return .concat([
        .just(.inputNickname(text)),
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
      
    case .inputNickname(let text):
      newState.inputedText = text
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
  func toMutation() -> Observable<ProfileEditJobAndSchoolReactor.Mutation> {
    let errorMutation: Observable<ProfileEditJobAndSchoolReactor.Mutation> = {
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

