//
//  AccountSecurityQuestionView.swift
//  FeatureOnboardingInterface
//
//  Created by HUNHIE LEE on 1/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SharedDesignSystem
import DomainAuth

public enum AccountSecurityAnswerType: Int, IntCaseIterable {
  case answer1
  case answer2
  case answer3
  case answer4
  case answer5
}

public enum AccountSecurityQuestionType {
  case nickname([AuthCheckQuestionItem])
  case birth([AuthCheckQuestionItem])
  
  var questionTitle: String {
    switch self {
    case .nickname:
      return """
            사용했던 닉네임을
            선택해주세요
            """
    case .birth:
      return """
            설정했던 출생년도를
            선택해주세요
            """
    }
  }
  
  var stepValue: String {
    switch self {
    case .nickname:
      return "1단계"
    case .birth:
      return "2단계"
    }
  }
}

public final class AccountSecurityQuestionView: BaseView, Touchable {
  // MARK: - View Property
  private let titleLabel: UILabel = UILabel().then {
    $0.font = SystemFont.headLine01.font
    $0.numberOfLines = 2
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  
  private let stepLabel: UILabel = UILabel().then {
    $0.font = SystemFont.title04.font
    $0.textColor = SystemColor.gray700.uiColor
  }
  
  private lazy var answerView: RadioSegmentControl = RadioSegmentControl<AccountSecurityAnswerType>()
  
  private let continueButton: FillButton = FillButton().then {
    typealias Config = FillButton.Configuration
    let enabled = Config(backgroundColor: SystemColor.primaryNormal.uiColor, isEnabled: true)
    let disabled = Config(backgroundColor: SystemColor.gray300.uiColor, isEnabled: false)
    
    $0.title = "계속하기"
    $0.setState(enabled, for: .enabled)
    $0.setState(disabled, for: .disabled)
    $0.cornerRadius = 8
    $0.currentState = .disabled
  }
  
  // MARK: - Stored Property
  public let items: PublishRelay<[RadioSegmentItem]> = .init()
  
  private let step: AccountSecurityQuestionType
  
  // MARK: - Reactor Property
  private let disposeBag: DisposeBag = DisposeBag()
  
  // MARK: - Initialize Method
  public init(step: AccountSecurityQuestionType) {
    self.step = step
    super.init(frame: .zero)
    setTitleforStep(step)
  }
  
  // MARK: - Touchable
  public var touchEventRelay: PublishRelay<TouchEventType> = .init()
  
  // MARK: - UIConfigurable
  public override func configureUI() {
    setupTitleLabel()
    setupStepLabel()
    setupAnswerView()
    setupContinue()
  }
  
  public override func bind() {
    items
      .bind(to: answerView.items)
      .disposed(by: disposeBag)
    
    answerView.touchEventRelay
      .map { .answer($0) }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    continueButton.touchEventRelay
      .map { .continueButton }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
  
  private func setupTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
  }
  
  private func setupStepLabel() {
    addSubview(stepLabel)
    stepLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(16)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
  }
  
  private func setupAnswerView() {
    addSubview(answerView)
    answerView.snp.makeConstraints {
      $0.top.equalTo(stepLabel.snp.bottom).offset(56)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
  }
  
  private func setupContinue() {
    addSubview(continueButton)
    continueButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-16)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(52)
    }
  }
  
  private func setTitleforStep(_ step: AccountSecurityQuestionType) {
    titleLabel.text = step.questionTitle
    stepLabel.text = step.stepValue
  }
  
  public func setContinueButtonIsEnabled(for state: Bool) {
    continueButton.currentState = state ? .enabled : .disabled
  }
}

extension AccountSecurityQuestionView {
  public enum TouchEventType {
    case answer(AccountSecurityAnswerType)
    case continueButton
  }
}
