//
//  BottomLineTextField.swift
//  SharedDesignSystem
//
//  Created by walkerhilla on 1/4/24.
//

import UIKit
import RxCocoa

open class BottomLineTextField: BaseView, InputReceivable {
  // MARK: - View Property
  public let textField: UITextField = UITextField()
  
  private let bottomLine: BackgroundView = BackgroundView().then {
    typealias Configuration = BackgroundView.Configuration
    let inactiveConfig = Configuration(backgroundColor: SystemColor.gray300.uiColor)
    let activateConfig = Configuration(backgroundColor: SystemColor.primaryNormal.uiColor)
    
    $0.setState(inactiveConfig, for: .inactive)
    $0.setState(activateConfig, for: .activate)
    
    $0.currentState = .inactive
  }
  
  public var noticeValue: String? {
    didSet {
      noticeLabel.text = noticeValue
    }
  }
  
  private let noticeLabel: UILabel = UILabel().then {
    $0.font = SystemFont.caption02.font
    $0.textColor = SystemColor.systemErrorRed.uiColor
  }
  
  private let maxTextLength: Int
  
  // MARK: - InputReceivable
  public let inputEventRelay: PublishRelay<String> = .init()
  
  // MARK: - Initialize Method
  public init(maxTextLength: Int) {
    self.maxTextLength = maxTextLength
    super.init(frame: .zero)
    textField.delegate = self
  }
  
  // MARK: - UIConfigurable
  open override func configureUI() {
    addSubview(textField)
    textField.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    addSubview(bottomLine)
    bottomLine.snp.makeConstraints {
      $0.top.equalTo(textField.snp.bottom)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(1.5)
    }
    
    addSubview(noticeLabel)
    noticeLabel.snp.makeConstraints {
      $0.top.equalTo(bottomLine).offset(8)
      $0.leading.equalToSuperview()
    }
  }
}

extension BottomLineTextField: UITextFieldDelegate {
  public func textFieldDidBeginEditing(_ textField: UITextField) {
    bottomLine.currentState = .activate
  }
  
  public func textFieldDidEndEditing(_ textField: UITextField) {
    bottomLine.currentState = .inactive
  }
  
  public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let currentText = textField.text, let range = Range(range, in: currentText) else { return true }
    let updatedText = currentText.replacingCharacters(in: range, with: string)
    guard maxTextLength >= updatedText.count else { return false }
    inputEventRelay.accept(updatedText)
    
    return true
  }
}
