//
//  AccountSecurityQuestionController.swift
//  FeatureOnboardingInterface
//
//  Created by HUNHIE LEE on 1/30/24.
//

import UIKit
import RxSwift
import ReactorKit
import SharedDesignSystem

public final class AccountSecurityQuestionController: BaseController {
  public lazy var mainView: AccountSecurityQuestionView = .init(step: step)
  
  private let step: AccountSecurityQuestionType
  
  weak var delegate: AccountOwnerCheckDelegate?
  
  // MARK: - Initialize Method
  public required init(reactor: Reactor, step: AccountSecurityQuestionType) {
    self.step = step
    defer {
      self.reactor = reactor
    }
    super.init()
  }
  
  public override func configureUI() {
    view.addSubview(mainView)
    mainView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(52)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

extension AccountSecurityQuestionController: ReactorKit.View {
  public typealias Reactor = AccountSecurityQuestionReactor
  
  public func bind(reactor: Reactor) {
    mainView.touchEventRelay
      .bind(with: self) { owner, touchType in
        switch touchType {
        case .answer(let accountSecurityAnswerType):
          reactor.action.onNext(.answerSelected(accountSecurityAnswerType))
        case .continueButton:
          reactor.action.onNext(.answerEntered)
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.isContinueButtonEnabled)
      .distinctUntilChanged()
      .bind(with: self) { owner, state in
        owner.mainView.setContinueButtonIsEnabled(for: state)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.isCorrect)
      .bind(with: self) { owner, status in
        guard let status else { return }
        switch status {
        case .correct:
          switch owner.step {
          case .birth:
            break
          case .nickname:
            break
          }
        case .incorrect(let count):
          if count < 2 {
            owner.delegate?.pushToFailed(type: .unlocked)
          } else {
            owner.delegate?.pushToFailed(type: .locked)
          }
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.questions)
      .bind(with: self) { owner, questionType in
        guard let questionType else { return }
        switch questionType {
        case .birth(let question):
          let items = question.map { RadioSegmentItem(id: $0.id, title: $0.title) }
          owner.mainView.items.accept(items)
        case .nickname(let question):
          let items = question.map { RadioSegmentItem(id: $0.id, title: $0.title) }
          owner.mainView.items.accept(items)
        }
      }
      .disposed(by: disposeBag)
  }
}
