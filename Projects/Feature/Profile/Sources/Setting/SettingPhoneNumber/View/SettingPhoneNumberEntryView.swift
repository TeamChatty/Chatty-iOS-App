//
//  SettingPhoneNumberEntryView.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/11/24.
//
//
//import UIKit
//import RxSwift
//import RxCocoa
//import SnapKit
//import SharedDesignSystem
//import Then
//
//final class SettingPhoneNumberEntryView: BaseView, Touchable, InputReceivable {
//  // MARK: - View Property
//  private let titleLabel: UILabel = UILabel().then {
//    $0.text = "전화번호를 인증해 주세요"
//    $0.font = SystemFont.headLine01.font
//    $0.textColor = SystemColor.basicBlack.uiColor
//    $0.textAlignment = .natural
//  }
//  
//  private let subTitleLabel: UILabel = UILabel().then {
//    var paragraphStyle = NSMutableParagraphStyle()
//    paragraphStyle.lineHeightMultiple = 1.17
//    let text = "채티를 더욱 안전하고 신뢰할 수 있는 공간으로 만들어요. 입력한 전화번호는 절대 공개되지 않아요."
//    $0.attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
//    $0.font = SystemFont.title04.font
//    $0.textColor = SystemColor.gray700.uiColor
//    $0.textAlignment = .natural
//    $0.numberOfLines = 0
//  }
//  
//  private let phoneNumberField: BottomLineTextField = BottomLineTextField(maxTextLength: 11).then {
//    $0.textField.keyboardType = .numberPad
//    $0.textField.attributedPlaceholder = NSAttributedString(
//      string: "전화번호 입력 (- 없이 숫자만 입력)",
//      attributes: [
//        .font: SystemFont.title01.font,
//        .foregroundColor: SystemColor.gray400.uiColor
//      ]
//    )
//    $0.textField.font = SystemFont.title01.font
//    $0.textField.textColor = SystemColor.basicBlack.uiColor
//    $0.textField.tintColor = SystemColor.primaryNormal.uiColor
//  }
//  
//  private let requestSMSButton: FillButton = FillButton().then {
//    typealias Configuration = FillButton.Configuration
//    let enabledConfig = Configuration(backgroundColor: SystemColor.primaryNormal.uiColor, isEnabled: true)
//    let disabledConfig = Configuration(backgroundColor: SystemColor.gray300.uiColor, isEnabled: false)
//    
//    $0.title = "인증번호 보내기"
//    $0.cornerRadius = 8
//    $0.setState(enabledConfig, for: .enabled)
//    $0.setState(disabledConfig, for: .disabled)
//    $0.currentState = .disabled
//  }
//  
//  // MARK: - Rx Property
//  private let disposeBag = DisposeBag()
//  
//  // MARK: - Touchable
//  public let touchEventRelay: PublishRelay<Void> = .init()
//  
//  // MARK: - InputReceivable
//  public let inputEventRelay: PublishRelay<InputEventType> = .init()
//  
//  // MARK: - Initialize Method
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//  }
//  
//  // MARK: - UIConfigurable
//  override func configureUI() {
//    setupTitleLabel()
//    setupSubTitleLabel()
//    setupPhoneNumberField()
//    setupRequestSMSButton()
//  }
//  
//  override func bind() {
//    phoneNumberField.inputEventRelay
//      .map { .phoneNumber($0) }
//      .bind(to: inputEventRelay)
//      .disposed(by: disposeBag)
//    
//    requestSMSButton.touchEventRelay
//      .bind(to: touchEventRelay)
//      .disposed(by: disposeBag)
//  }
//}
//
//extension SettingPhoneNumberEntryView {
//  enum InputEventType {
//    case phoneNumber(String)
//  }
//  
//  private func setupTitleLabel() {
//    addSubview(titleLabel)
//    titleLabel.snp.makeConstraints {
//      $0.top.equalToSuperview().offset(16)
//      $0.leading.trailing.equalToSuperview().inset(20)
//    }
//  }
//  
//  private func setupSubTitleLabel() {
//    addSubview(subTitleLabel)
//    subTitleLabel.snp.makeConstraints {
//      $0.top.equalTo(titleLabel.snp.bottom).offset(16)
//      $0.leading.trailing.equalToSuperview().inset(20)
//    }
//  }
//  
//  private func setupPhoneNumberField() {
//    addSubview(phoneNumberField)
//    phoneNumberField.snp.makeConstraints {
//      $0.top.equalTo(subTitleLabel.snp.bottom).offset(64)
//      $0.leading.trailing.equalToSuperview().inset(20)
//      $0.height.equalTo(50)
//    }
//  }
//  
//  public func activatePhoneNumberField() {
//    phoneNumberField.textField.becomeFirstResponder()
//  }
//  
//  private func setupRequestSMSButton() {
//    addSubview(requestSMSButton)
//    requestSMSButton.snp.makeConstraints {
//      $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-16)
//      $0.horizontalEdges.equalToSuperview().inset(20)
//      $0.height.equalTo(50)
//    }
//  }
//  
//  public func setRequestSMSButtonIsEnabled(for state: Bool) {
//    self.requestSMSButton.currentState = state ? .enabled : .disabled
//  }
//}
