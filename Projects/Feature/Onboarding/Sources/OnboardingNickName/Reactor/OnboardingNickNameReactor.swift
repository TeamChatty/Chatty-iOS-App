//
//  OnboardingNickNameCoordinatorReactor.swift
//  FeatureOnboardingInterface
//
//  Created by 윤지호 on 1/4/24.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import DomainUserInterface
import DomainCommon

public final class OnboardingNickNameReactor: Reactor {
  private let saveProfileNicknameUseCase: SaveProfileNicknameUseCase
  private let getUserDataUseCase: GetUserDataUseCase
  
  /// 뷰에서 수행할 수 있는 사용자의 액션
  public enum Action {
    case inputText(String)
    case tabContinueButton
    case didPushed
  }
    
  /// 화면의 상태가 변화하는 요인
  public enum Mutation {
    case inputedText(String)
    case nicknameValid(CheckedResultType)
    case isSavedSuccess
    case isLoading(Bool)
    case didPushed
    case setError(ErrorType?)
  }
  
  /// 화면의 상태를 나타내는 구조체
  public struct State {
    var nickNameText: String
    var checkedResult: CheckedResultType = .none
    var isButtonEnabled: Bool = false
    var successSave: Bool = false
    var isLoading: Bool = false
    var errorState: ErrorType? = nil
    
    init() {
      nickNameText = ""
    }
  }
  
  public var initialState: State = State()
  
  init(saveProfileNicknameUseCase: SaveProfileNicknameUseCase, getUserDataUseCase: GetUserDataUseCase) {
    self.saveProfileNicknameUseCase = saveProfileNicknameUseCase
    self.getUserDataUseCase = getUserDataUseCase
  }
}

extension OnboardingNickNameReactor {
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .inputText(let string):
      let checkedResult = isNicknameValid(string)
      return .concat([
        .just(.inputedText(string)),
        .just(.nicknameValid(checkedResult))
      ])
    case .tabContinueButton:
      /// 닉네임
      if currentState.nickNameText == getUserDataUseCase.execute().nickname {
        return .just(.isSavedSuccess)
      } else {
        return .concat([
          .just(.isLoading(true)),
          self.saveProfileNicknameUseCase.excute(nickname: self.currentState.nickNameText)
            .asObservable()
            .map { _ in .isSavedSuccess }
            .catch { error -> Observable<Mutation> in
              return error.toMutation()
            },
          .just(.isLoading(false))
        ])
      }
    case .didPushed:
      return .just(.didPushed)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .inputedText(let string):
      newState.nickNameText = string
    case .nicknameValid(let result):
      newState.checkedResult = result
      newState.isButtonEnabled = result == .none ? true : false
    case .isSavedSuccess:
      newState.successSave = true
    case .isLoading(let bool):
      newState.isLoading = bool
    case .didPushed:
      newState.successSave = false
    case .setError(let error):
      newState.errorState = error
    }
    return newState
  }
  
  private func isNicknameValid(_ nicknameStr: String) -> CheckedResultType {
    if nicknameStr.count > 10 {
      return .outOfRange
    } else if nicknameStr.isEmpty {
      return .empty
    } else {
      return .none
    }
  }
  
  public enum ErrorType: Error {
    case duplicatedNickname
    case unknownError
  }
}

extension Error {
  func toMutation() -> Observable<OnboardingNickNameReactor.Mutation> {
    let errorMutation: Observable<OnboardingNickNameReactor.Mutation> = {
      guard let error = self as? NetworkError else {
        return .just(.setError(.unknownError))
      }
      switch error.errorCase {
      case .E006AlreadyExistNickname:
        return .concat([
          .just(.setError(.duplicatedNickname)),
          .just(.nicknameValid(.duplication))
        ])
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
