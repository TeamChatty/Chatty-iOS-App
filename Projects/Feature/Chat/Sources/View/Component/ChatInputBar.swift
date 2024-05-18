//
//  ChatInputBar.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 2/13/24.
//

import UIKit
import RxSwift
import RxCocoa
import SharedDesignSystem
import DomainChatInterface

public final class ChatInputBar: BaseView, InputReceivable, Touchable {
  private let dividerView: BackgroundView = BackgroundView().then {
    $0.backgroundColor = SystemColor.gray200.uiColor
  }
  
  public lazy var textView: UITextView = UITextView().then {
    $0.showsVerticalScrollIndicator = false
    $0.font = SystemFont.body03.font
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.isScrollEnabled = false
    $0.textContainerInset = .init(top: 2, left: 0, bottom: 0, right: 0)
    $0.backgroundColor = SystemColor.gray100.uiColor
  }
  
  private let inputBar: UIView = UIView().then {
    $0.layer.cornerRadius = 12
    $0.layer.borderColor = SystemColor.gray200.uiColor.cgColor
    $0.layer.borderWidth = 1
    $0.backgroundColor = SystemColor.gray100.uiColor
  }
  
  private let sendButton: ChangeableImageButton = ChangeableImageButton().then {
    typealias Config = ChangeableImageButton.Configuration
    let image = UIImage(asset: Images.send)!.withRenderingMode(.alwaysTemplate)
    let disabled = Config(image: image, tintColor: SystemColor.gray500.uiColor, isEnabled: false)
    let enabled = Config(image: image, tintColor: SystemColor.primaryNormal.uiColor, isEnabled: true)
    $0.setState(disabled, for: .disabled)
    $0.setState(enabled, for: .enabled)
    $0.currentState = .disabled
  }
  
  public var isEditable: Bool = false {
    didSet {
      textView.isEditable = isEditable
    }
  }
  
  public var inputEventRelay: PublishRelay<MessageContentType> = .init()
  public var touchEventRelay: PublishRelay<Void> = .init()
  private let disposeBag: DisposeBag = DisposeBag()
  
  public override func configureUI() {
    self.backgroundColor = SystemColor.basicWhite.uiColor
    setupDividerView()
    setupInputBar()
    setupSendButton()
    setupTextView()
  }
  
  public override func bind() {
    super.bind()
    textView.rx.tapGesture()
    .when(.recognized)
    .map { _ in () }
    .bind(to: touchEventRelay)
    .disposed(by: disposeBag)
    
    sendButton.touchEventRelay
      .withUnretained(self)
      .map { _ in .text(self.textView.text) }
      .do { _ in
        self.textView.text = nil
      }
      .bind(to: inputEventRelay)
      .disposed(by: disposeBag)
  }
  
  private func setupDividerView() {
    addSubview(dividerView)
    dividerView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.height.equalTo(1)
    }
  }
  
  private func setupInputBar() {
    addSubview(inputBar)
    inputBar.snp.makeConstraints {
      $0.verticalEdges.equalToSuperview().inset(8)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
  }
  
  private func setupSendButton() {
    inputBar.addSubview(sendButton)
    sendButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-12)
      $0.bottom.equalToSuperview().offset(-10)
      $0.size.equalTo(24)
    }
  }
  
  private func setupTextView() {
    inputBar.addSubview(textView)
    textView.snp.makeConstraints {
      $0.verticalEdges.leading.equalToSuperview().inset(12)
      $0.trailing.equalTo(sendButton.snp.leading).offset(-12)
    }
  }
  
  public func updateSendButtonIsEnabled(_ isEnabled: Bool) {
    sendButton.currentState = isEnabled ? .enabled : .disabled
  }
}
