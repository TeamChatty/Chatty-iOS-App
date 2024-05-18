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
      .bind(with: self) { [weak self] owner, touchType in
        switch touchType {
        case .answer(let accountSecurityAnswerType):
          print("정답 선택")
          reactor.action.onNext(.answerSelected(accountSecurityAnswerType))
        case .continueButton:
          print("계속하기")
          guard let self,
                let answerPicker = reactor.currentState.answer?.rawValue else { return }
          switch self.step {
          case .birth(let items):
            print("생년월일")
            reactor.action.onNext(.answerEntered(type: .birth, answer: items[answerPicker].title))
          case .nickname(let items):
            print("닉네임")
            reactor.action.onNext(.answerEntered(type: .nickname, answer: items[answerPicker].title))
          }
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
            print("정답입니다~")
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
    
    rx.viewDidLoad
      .bind(with: self) { owner, _ in
        switch owner.step {
        case .birth(let question):
          let items = question.map { RadioSegmentItem(id: $0.id, title: $0.title) }
          owner.mainView.items.accept(items)
        case .nickname(let question):
          let items = question.map {
            print($0.title)
            return RadioSegmentItem(id: $0.id, title: $0.title)
          }
          owner.mainView.items.accept(items)
        }
      }
      .disposed(by: disposeBag)
  }
}
