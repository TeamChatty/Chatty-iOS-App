//
//  OnboardingVerificationCodeEntryView.swift
//  FeatureOnboarding
//
//  Created by walkerhilla on 1/8/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import SharedDesignSystem
import Then

final class OnboardingVerificationCodeEntryView: BaseView, Touchable, InputReceivable {
  // MARK: - View Property
  private let titleLabel: UILabel = UILabel().then {
    $0.text = "인증번호를 입력해주세요"
    $0.font = SystemFont.headLine01.font
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.textAlignment = .natural
    $0.sizeToFit()
  }
  
  private let subTitleLabel: UILabel = UILabel().then {
    $0.font = SystemFont.title04.font
    $0.textColor = SystemColor.gray700.uiColor
    $0.textAlignment = .natural
    $0.numberOfLines = 0
    $0.sizeToFit()
  }
  
  private let verificationCodeField: BottomLineTextField = BottomLineTextField(maxTextLength: 6).then {
    $0.textField.keyboardType = .numberPad
    $0.textField.attributedPlaceholder = NSAttributedString(
      string: "6자리 숫자",
      attributes: [
        .font: SystemFont.title01.font,
        .foregroundColor: SystemColor.gray400.uiColor
      ]
    )
    $0.textField.font = SystemFont.title01.font
    $0.textField.textColor = SystemColor.basicBlack.uiColor
    $0.textField.tintColor = SystemColor.primaryNormal.uiColor
  }
  
  private let requestSMSButton: PlainButton = PlainButton().then {
    $0.title = "인증번호 다시 받기"
  }
  
  // MARK: - Stored Property
  public var phoneNumber: String? {
    didSet {
      setSubtitleLabel(phoneNumber)
    }
  }
  
  public var title: String? {
    didSet {
      titleLabel.text = title
    }
  }
  
  enum ErrorNoticeType {
    case authentificationError(Int)
  }
  
  public var errorNoticeType: ErrorNoticeType? {
    didSet {
      guard let errorNoticeType else { return }
      switch errorNoticeType {
      case .authentificationError(let count):
        let value = count < 5 ? "오늘 \(5 - count)번 더 요청할 수 있어요" : "오늘 요청 횟수를 전부 사용했어요"
        verificationCodeField.noticeValue = value
      }
    }
  }
  
  // MARK: - Reactor Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable
  public let touchEventRelay: PublishRelay<Void> = .init()
  
  // MARK: - InputReceivable
  public let inputEventRelay: PublishRelay<String> = .init()
  
  public override func configureUI() {
    setupTitleLabel()
    setupSubTitleLabel()
    setupVerificationCodeField()
    setupRequestSMSButton()
  }
  
  override func bind() {
    verificationCodeField.inputEventRelay
      .bind(to: inputEventRelay)
      .disposed(by: disposeBag)
  }
}

extension OnboardingVerificationCodeEntryView {
  
  private func setupTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
  }
  
  private func setupSubTitleLabel() {
    addSubview(subTitleLabel)
    subTitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(16)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
  }
  
  private func setupVerificationCodeField() {
    addSubview(verificationCodeField)
    verificationCodeField.snp.makeConstraints {
      $0.top.equalTo(subTitleLabel.snp.bottom).offset(64)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(50)
    }
  }
  
  public func activateVerificationCodeField() {
    verificationCodeField.textField.becomeFirstResponder()
  }
  
  private func setupRequestSMSButton() {
    addSubview(requestSMSButton)
    requestSMSButton.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top)
      $0.height.equalTo(60)
    }
  }
  
  private func setSubtitleLabel(_ phoneNumber: String?) {
    guard let phoneNumber else { return }
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.17
    let text = "번호가 담긴 메시지를 \(phoneNumber)로 보냈어요. 절대 타인에게 공유하면 안돼요."
    let attributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    if let range = text.range(of: phoneNumber) {
      let nsRange = NSRange(range, in: text)
      attributedString.addAttribute(.foregroundColor, value: SystemColor.primaryNormal.uiColor, range: nsRange)
    }
    
    subTitleLabel.attributedText = attributedString
  }
}
