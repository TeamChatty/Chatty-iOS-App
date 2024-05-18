//
//  AccountSecurityQuestionReactor.swift
//  FeatureOnboardingInterface
//
//  Created by HUNHIE LEE on 1/31/24.
//

import UIKit
import RxSwift
import ReactorKit
import SharedDesignSystem
import DomainAuth
import DomainAuthInterface

public final class AccountSecurityQuestionReactor: Reactor {
  private let getAuthCheckProblemUseCase: DefaultGetAuthCheckQuestionUseCase
  private let getAuthCheckProfileUseCase: DefaultGetAuthCheckProfileUseCase
  private let postAuthCheckAnswerUseCase: DefaultPostAuthCheckAnswerIUseCase
  
  public enum Action {
    case getProfileImage
    case getQuestionNickname
    case getQuestionBirth
    case answerSelected(AccountSecurityAnswerType)
    case answerEntered(type: AuthCheckType, answer: String)
  }
  
  public enum Mutation {
    case setProfileImage(String?)
    case setQuestion(AccountSecurityQuestionType)
    case setAnswer(AccountSecurityAnswerType)
    case setContinueButton(Bool)
    case setCorrect(AnswerStatus)
  }
  
  public struct State {
    var questions: AccountSecurityQuestionType?
    var answer: AccountSecurityAnswerType?
    var isCorrect: AnswerStatus? = nil
    var isContinueButtonEnabled: Bool = false
    var profileImageURL: String?
  }
  
  public let initialState: State = State()
  
  public init(getAuthCheckProblemUseCase: DefaultGetAuthCheckQuestionUseCase, getAuthCheckProfileUseCase: DefaultGetAuthCheckProfileUseCase, postAuthCheckAnswerUseCase: DefaultPostAuthCheckAnswerIUseCase) {
    self.getAuthCheckProblemUseCase = getAuthCheckProblemUseCase
    self.getAuthCheckProfileUseCase = getAuthCheckProfileUseCase
    self.postAuthCheckAnswerUseCase = postAuthCheckAnswerUseCase
  }
}

extension AccountSecurityQuestionReactor {
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .answerEntered(let type, let answer):      
      return postAuthCheckAnswerUseCase.execute(type: type, answer: answer)
        .asObservable()
        .flatMap { bool -> Observable<Mutation> in
          let isCorrect: AnswerStatus = bool ? .correct : .incorrect(0)
          return .just(.setCorrect(.correct))
        }
    case .answerSelected(let answer):
      return .from(
        [
          .setContinueButton(true),
          .setAnswer(answer)
        ]
      )
    case .getQuestionBirth:
      return getAuthCheckProblemUseCase.executeForBirth()
        .asObservable()
        .flatMap { question -> Observable<Mutation> in
          let questionItem = question.enumerated().map { index, item in
            AuthCheckQuestionItem(id: index, title: item)
          }
          return .just(.setQuestion(.birth(questionItem)))
        }
    case .getQuestionNickname:
      return getAuthCheckProblemUseCase.executeForNickname()
        .asObservable()
        .flatMap { question -> Observable<Mutation> in
          let questionItem = question.enumerated().map { index, item in
            AuthCheckQuestionItem(id: index, title: item)
          }
          return .just(.setQuestion(.nickname(questionItem)))
        }
    case .getProfileImage:
      return getAuthCheckProfileUseCase.execute()
        .asObservable()
        .flatMap { profileImageURL -> Observable<Mutation> in
          return .just(.setProfileImage(profileImageURL))
        }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setCorrect(let status):
      newState.isCorrect = status
    case .setContinueButton(let bool):
      newState.isContinueButtonEnabled = bool
    case .setAnswer(let answer):
      newState.answer = answer
    case .setQuestion(let type):
      switch type {
      case .nickname(let items):
        newState.questions = .nickname(items)
      case .birth(let items):
        newState.questions = .birth(items)
      }
    case .setProfileImage(let profileImageURL):
      newState.profileImageURL = profileImageURL
    }
    return newState
  }
  
  public enum AnswerStatus: Equatable {
    case correct
    case incorrect(Int)
  }
}
