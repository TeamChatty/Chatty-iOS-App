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

public final class AccountSecurityQuestionReactor: Reactor {
  private let getAuthCheckProblemUseCase: DefaultGetAuthCheckQuestionUseCase
  
  public enum Action {
    case getQuestionNickname
    case getQuestionBirth
    case answerSelected(AccountSecurityAnswerType)
    case answerEntered
  }
  
  public enum Mutation {
    case setQuestion(AccountSecurityQuestionType)
    case setAnswer(AccountSecurityAnswerType)
    case setContinueButton(Bool)
    case answerEnter
  }
  
  public struct State {
    var questions: AccountSecurityQuestionType?
    var answer: AccountSecurityAnswerType?
    var isCorrect: AnswerStatus? = nil
    var isContinueButtonEnabled: Bool = false
  }
  
  public let initialState: State = State()
  
  public init(getAuthCheckProblemUseCase: DefaultGetAuthCheckQuestionUseCase) {
    self.getAuthCheckProblemUseCase = getAuthCheckProblemUseCase
  }
}

extension AccountSecurityQuestionReactor {
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .answerEntered:
      return .just(.answerEnter)
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
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .answerEnter:
      if newState.answer == .answer1 {
        newState.isCorrect = .correct
      } else {
        newState.isCorrect = .incorrect(Int.random(in: 1...2))
      }
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
    }
    return newState
  }
  
  enum AnswerStatus: Equatable {
    case correct
    case incorrect(Int)
  }
}
