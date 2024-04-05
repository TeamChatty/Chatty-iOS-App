//
//  ProfileEditJobView.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/5/24.
//


import UIKit
import RxSwift
import RxCocoa
import SharedDesignSystem

final class ProfileEditJobAndSchoolView: BaseView, Touchable {
  // MARK: - View Property
  private let cancelButton: CancelButton = CancelButton()
  private let titleLabel: UILabel = UILabel().then {
    $0.text = "닉네임 변경"
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.title02.font
  }

  private let jobTextField: PaddingTextField = PaddingTextField(maxTextLength: 30).then {
    $0.textField.attributedPlaceholder = NSAttributedString(
      string: "최대 30자",
      attributes: [
        .font: SystemFont.title04.font,
        .foregroundColor: SystemColor.gray500.uiColor
      ]
    )
    $0.textField.font = SystemFont.title04.font
    $0.textField.textColor = SystemColor.basicBlack.uiColor
    
    $0.backgroundColor = SystemColor.gray100.uiColor
    $0.layer.cornerRadius = 8
  }
  
  private let descriptionLabel: UILabel = UILabel().then {
    $0.text = "나중에 변경할 수 있어요. 편하게 입력해 주세요."
    $0.textColor = SystemColor.gray700.uiColor
    $0.font = SystemFont.caption02.font
  }
  
  private let changeButton: FillButton = FillButton().then {
    $0.title = "변경하기"
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
    setupDescriptionLabel()
    setupChangeButton()
  }
  
  // MARK: - UIBindable
  override func bind() {
    cancelButton.touchEventRelay
      .map { TouchEventType.cancel }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    jobTextField.inputEventRelay
      .map { TouchEventType.inputText($0) }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    changeButton.touchEventRelay
      .map { TouchEventType.change }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension ProfileEditJobAndSchoolView {
  enum TouchEventType {
    case cancel
    case inputText(String)
    case change
  }
}

extension ProfileEditJobAndSchoolView {
  private func setupHeader() {
    addSubview(titleLabel)
    addSubview(cancelButton)
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(32)
      $0.leading.equalToSuperview().inset(20)
      $0.height.equalTo(22)
    }
    
    cancelButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(32)
      $0.size.equalTo(24)
      $0.trailing.equalToSuperview().inset(20)
    }
  }
  
  private func setupTextField() {
    addSubview(jobTextField)
    jobTextField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(30)
      $0.height.equalTo(48)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
  }
  
  private func setupDescriptionLabel() {
    addSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(jobTextField.snp.bottom).offset(32)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(18)
    }
  }
  
  private func setupChangeButton() {
    addSubview(changeButton)
    changeButton.snp.makeConstraints {
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(12)
      $0.height.equalTo(52)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(16)
    }
  }
}

extension ProfileEditJobAndSchoolView {
  func setProfileType(profileType: ProfileEditType) {
    titleLabel.text = profileType == .job ? "직업 입력" : "학교 입력"
  }
  
  
  func setChangeButtonEnabled(_ isEnabled: Bool) {
    changeButton.currentState = isEnabled ? .enabled: .disabled
  }
  
  func setErrorLabel(errorText: String?) {

  }
}

