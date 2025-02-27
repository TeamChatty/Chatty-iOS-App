//
//  OnboardingNickNameCoordinatorView.swift
//  FeatureOnboardingInterface
//
//  Created by 윤지호 on 1/4/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import SharedDesignSystem

public final class OnboardingNickNameView: BaseView, Touchable, InputReceivable {
  // MARK: - View Property
  private let titleTextView: TitleTextView = TitleTextView().then {
    $0.updateTitleLabels(.none)
  }
  
  private let nickNameTextField: BottomLineTextField = BottomLineTextField(maxTextLength: 10).then {
    $0.textField.attributedPlaceholder = NSAttributedString(
      string: "최대 10자",
      attributes: [
        .font: SystemFont.title01.font,
        .foregroundColor: SystemColor.gray400.uiColor
      ]
    )
    $0.textField.font = SystemFont.title01.font
    $0.textField.textColor = SystemColor.basicBlack.uiColor
    $0.textField.tintColor = SystemColor.primaryNormal.uiColor
  }
  
  private let textValidLabel: UILabel = UILabel().then {
    $0.font = SystemFont.caption02.font
    $0.textColor = SystemColor.systemErrorRed.uiColor
  }
  
  private let warningLabel: UILabel = UILabel().then {
    $0.text = "다른 사람에게 불쾌감을 주는 닉네임은 제재돼요."
    $0.font = SystemFont.caption02.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  
  private let continueButton: FillButton = FillButton().then {
    typealias Configuration = FillButton.Configuration
    let disabledConfig = Configuration(backgroundColor: SystemColor.gray300.uiColor, isEnabled: false)
    let enabledCofig = Configuration(backgroundColor: SystemColor.primaryNormal.uiColor, isEnabled: true)
    
    $0.title = "계속하기"
    $0.cornerRadius = 8

    $0.setState(enabledCofig, for: .enabled)
    $0.setState(disabledConfig, for: .disabled)
  }
  
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable
  public let touchEventRelay: PublishRelay<TouchType> = .init()
  
  // MARK: - InputReceivable
  public var inputEventRelay: PublishRelay<InputEventType> = .init()

  
  // MARK: - Life Cycle
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UIConfigurable
  public override func configureUI() {
    setupTitleTextView()
    setupTextField()
    setupTextValidLabel()
    setupContinueButton()
    setupWarningLabel()
  }
  
  // MARK: - UIBindable
  public override func bind() {
    continueButton.touchEventRelay
      .map { TouchType.continueButton }
      .bind(to: self.touchEventRelay)
      .disposed(by: disposeBag)
    
    nickNameTextField.inputEventRelay
      .map { InputEventType.nickNameText($0) }
      .bind(to: inputEventRelay)
      .disposed(by: disposeBag)
  }
}

extension OnboardingNickNameView {
  public enum InputEventType {
    case nickNameText(String)
  }
  
  public enum TouchType {
    case continueButton
  }

  private func setupTitleTextView() {
    addSubview(titleTextView)
    titleTextView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(91)
    }
  }
  
  private func setupTextField() {
    addSubview(nickNameTextField)
    nickNameTextField.snp.makeConstraints {
      $0.top.equalTo(titleTextView.snp.bottom).offset(64)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(50)
    }
  }
  
  private func setupTextValidLabel() {
    addSubview(textValidLabel)
    textValidLabel.snp.makeConstraints {
      $0.top.equalTo(nickNameTextField.snp.bottom).offset(8)
      $0.height.equalTo(18)
      $0.trailing.leading.equalTo(nickNameTextField)
    }
  }
  
  private func setupWarningLabel() {
    addSubview(warningLabel)
    warningLabel.snp.makeConstraints {
      $0.bottom.equalTo(continueButton.snp.top).offset(-11)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(18)
    }
  }
  
  private func setupContinueButton() {
    addSubview(continueButton)
    continueButton.snp.makeConstraints {
      $0.height.equalTo(52)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-16)
    }
  }
}

extension OnboardingNickNameView {
  public func updateTextFieldBottomLine(_ state: CheckedResultType) {
    textValidLabel.text = state.description
  }
  
  public func updateContinueButtonEnabled(_ state: Bool) {
    continueButton.currentState = state ? .enabled : .disabled
  }
}
