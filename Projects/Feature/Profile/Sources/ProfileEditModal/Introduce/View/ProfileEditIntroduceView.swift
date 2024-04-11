//
//  ProfileEditIntroduceView.swift
//  FeatureProfileInterface
//
//  Created by 윤지호 on 4/4/24.
//

import UIKit
import RxSwift
import RxCocoa
import SharedDesignSystem

final class ProfileEditIntroduceView: BaseView, Touchable {
  // MARK: - View Property
  private let cancelButton: CancelButton = CancelButton()
  private let titleLabel: UILabel = UILabel().then {
    $0.text = "자기소개"
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.title02.font
  }
  private let descriptionLabel: UILabel = UILabel().then {
    $0.text = "나를 잘 나타낼 수 있는 문장을 작성해 주세요."
    $0.textColor = SystemColor.gray600.uiColor
    $0.font = SystemFont.body01.font
  }
 
  private let introduceTextField: PaddingTextView = PaddingTextView(maxTextLength: 500).then {
    $0.textView.font = SystemFont.body01.font
    $0.textView.textColor = SystemColor.basicBlack.uiColor
    
    $0.placeholderText = "내 소개를 10자 이상 작성해주세요. 예를 들면 최근 관심사, 쉬는 날에는 뭐 하는지 등 상관없어요. 다만 성적인 내용을 암시하는 내용이나 SNS계정을 공유하면 채티 계정이 정지될 수 있습니다."
    $0.isPlaceholderEnabled = true
    
    $0.backgroundColor = SystemColor.gray100.uiColor
    $0.layer.cornerRadius = 8
  }
  private let textCountLabel: UILabel = UILabel().then {
    $0.textColor = SystemColor.gray700.uiColor
    $0.font = SystemFont.caption02.font
  }
  
  private let candyDescriptionLabel: UILabel = UILabel().then {
    $0.text = "나중에 변경할 수 있어요. 편하게 입력해 주세요."
    $0.textColor = SystemColor.gray700.uiColor
    $0.font = SystemFont.caption02.font
  }
  
  private let changeButton: FillButton = FillButton().then {
    $0.title = "확인"
    typealias Configuration = FillButton.Configuration
    let enabledConfig = Configuration(
      backgroundColor: SystemColor.primaryNormal.uiColor,
      isEnabled: true
    )
    let disabledConfig = Configuration(
      backgroundColor: SystemColor.gray300.uiColor,
      isEnabled: false
    )
    $0.setState(enabledConfig, for: .enabled)
    $0.setState(disabledConfig, for: .disabled)

    $0.currentState = .enabled
    $0.cornerRadius = 52 / 2
  }
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()

  // MARK: - UIConfigurable
  override func configureUI() {
    setupHeader()
    setupTextField()
    setupWarningLabel()
    setupChangeButton()
  }
  
  // MARK: - UIBindable
  override func bind() {
    cancelButton.touchEventRelay
      .map { TouchEventType.cancel }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    introduceTextField.inputEventRelay
      .map { TouchEventType.inputText($0) }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    changeButton.touchEventRelay
      .map { TouchEventType.change }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension ProfileEditIntroduceView {
  enum TouchEventType {
    case cancel
    case inputText(String)
    case change
  }
}

extension ProfileEditIntroduceView {
  private func setupHeader() {
    addSubview(titleLabel)
    addSubview(descriptionLabel)
    addSubview(cancelButton)
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(32)
      $0.leading.equalToSuperview().inset(20)
      $0.height.equalTo(22)
    }
    
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(12)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(20)
    }
    
    cancelButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(32)
      $0.size.equalTo(24)
      $0.trailing.equalToSuperview().inset(20)
    }
  }
  
  private func setupTextField() {
    addSubview(introduceTextField)
    addSubview(textCountLabel)
    
    introduceTextField.snp.makeConstraints {
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
      $0.height.equalTo(120)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    textCountLabel.snp.makeConstraints {
      $0.top.equalTo(introduceTextField.snp.bottom).offset(8)
      $0.height.equalTo(18)
      $0.trailing.equalToSuperview().inset(20)
    }
  }
  
  private func setupWarningLabel() {
    addSubview(candyDescriptionLabel)
    candyDescriptionLabel.snp.makeConstraints {
      $0.top.equalTo(textCountLabel.snp.bottom).offset(13)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(18)
    }
  }
  
  private func setupChangeButton() {
    addSubview(changeButton)
    changeButton.snp.makeConstraints {
      $0.top.equalTo(candyDescriptionLabel.snp.bottom).offset(12)
      $0.height.equalTo(52)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(16)
    }
  }
}

extension ProfileEditIntroduceView {
  func setTextCountLabel(text: String) {
    textCountLabel.text = "\(text.count)/500"
  }
  
  func setChangeButtonEnabled(_ isEnabled: Bool) {
    changeButton.currentState = isEnabled ? .enabled: .disabled
  }
  
  func setErrorLabel(errorText: String?) {
    
  }
}
