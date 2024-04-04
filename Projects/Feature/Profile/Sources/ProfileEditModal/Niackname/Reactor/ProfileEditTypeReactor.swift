//
//  ProfileEditTypeReactor.swift
//  FeatureOnboarding
//
//  Created by 윤지호 on 4/4/24.
//

import ReactorKit
import DomainUser
import DomainUserInterface
import DomainCommon

final class ProfileEditTypeReactor: Reactor {
  private let getUserDataUseCase: GetUserDataUseCase
  private let saveProfileNicknameUseCase: SaveProfileNicknameUseCase
  
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
    var profileData: UserProfile
    
    var inputedNicknameText: String = ""
    
    var isLoading: Bool = false
    var isChangeButtonEnabled = false
    var isSaveSuccess: Bool = false
    var errorState: ErrorType? = nil
  }
  
  var initialState: State
  
  public init(saveProfileNicknameUseCase: SaveProfileNicknameUseCase, getUserDataUseCase: GetUserDataUseCase) {
    self.getUserDataUseCase = getUserDataUseCase
    self.saveProfileNicknameUseCase = saveProfileNicknameUseCase
    self.initialState = State(profileData: getUserDataUseCase.execute())
  }
  
  public enum ErrorType: Error {
    case wrongParameter
    case duplicatedNickname
    case unknownError
    
    var description: String {
      switch self {
      case .wrongParameter:
        return "닉네임은 특수문자를 제외한 2~10자리여야 합니다."
      case .duplicatedNickname:
        return "누군가 이미 쓰고 있어요. 다른 닉네임을 입력해주세요."
      case .unknownError:
        return "문제가 생겼어요. 다시 시도해주세요."
      }
    }
  }
}

extension ProfileEditTypeReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tabChangeButton:
      return .concat([
        .just(.isLoading(true)),
        self.saveProfileNicknameUseCase.excute(nickname: self.currentState.inputedNicknameText)
          .asObservable()
          .map { _ in .setIsSaveSuccess }
          .catch { error -> Observable<Mutation> in
            return error.toMutation()
          },
        .just(.isLoading(false))
      ])
      
    case .inputNickname(let text):
      var isChangeButtonEnabled: Bool = false
      if text == currentState.profileData.nickname {
        isChangeButtonEnabled = false
      } else if text.isEmpty {
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
  func toMutation() -> Observable<ProfileEditTypeReactor.Mutation> {
    let errorMutation: Observable<ProfileEditTypeReactor.Mutation> = {
      guard let error = self as? NetworkError else {
        return .just(.setError(.unknownError))
      }
      switch error.errorCase {
      case .E000WrongParameter:
        return .just(.setError(.wrongParameter))
      case .E006AlreadyExistNickname:
        return .just(.setError(.duplicatedNickname))
      default:
        return .just(.setError(.unknownError))
      }
    }()
    
    return Observable.concat([
      errorMutation
    ])
  }
}
