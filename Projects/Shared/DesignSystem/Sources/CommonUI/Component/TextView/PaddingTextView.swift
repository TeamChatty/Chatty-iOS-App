//
//  PaddingTextView.swift
//  SharedDesignSystem
//
//  Created by 윤지호 on 4/5/24.
//

import UIKit
import RxSwift
import RxCocoa

open class PaddingTextView: BaseView, InputReceivable {
  // MARK: - View Property
  public let textView: UITextView = UITextView()
  
  private let maxTextLength: Int
  
  public override var backgroundColor: UIColor? {
    didSet {
      self.textView.backgroundColor = backgroundColor
    }
  }
  
  /// 모든 attribute를 설정 후 마지막에 작성
  public var isPlaceholderEnabled: Bool? {
    didSet {
      guard let isPlaceholderEnabled else { return }
      if isPlaceholderEnabled {
        self.textView.text = placeholderText
        self.textView.font = placeholderFont
        self.textView.textColor = placeholderTextColor
      } else {
        self.textView.text = ""
        self.textView.font = font
        self.textView.textColor = textColor
      }
    }
  }
  
  public var placeholderText: String = "Placeholder"
  public var placeholderFont: UIFont = SystemFont.body01.font
  public var placeholderTextColor: UIColor = SystemColor.gray500.uiColor
  
  public var font: UIFont = SystemFont.body01.font {
    didSet {
      self.textView.font = font
    }
  }
  public var textColor: UIColor = SystemColor.basicBlack.uiColor {
    didSet {
      self.textView.textColor = textColor
    }
  }

  // MARK: - InputReceivable
  public let inputEventRelay: PublishRelay<String> = .init()
  
  // MARK: - Initialize Method
  public init(maxTextLength: Int) {
    self.maxTextLength = maxTextLength
    super.init(frame: .zero)
    textView.delegate = self
  }
  
  // MARK: - UIConfigurable
  open override func configureUI() {
    addSubview(textView)
    textView.snp.makeConstraints {
      $0.horizontalEdges.verticalEdges.equalToSuperview().inset(16)
    }
  }
}

extension PaddingTextView: UITextViewDelegate {
  public func textViewDidBeginEditing(_ textView: UITextView) {
    if isPlaceholderEnabled == true {
      isPlaceholderEnabled = false
    }
  }
  
  public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    guard let currentText = textView.text, let range = Range(range, in: currentText) else { return true }
    let updatedText = currentText.replacingCharacters(in: range, with: text)
    guard updatedText != placeholderText else { return false}
    guard maxTextLength >= updatedText.count else { return false }
    inputEventRelay.accept(updatedText)
    
    return true
  }
}
