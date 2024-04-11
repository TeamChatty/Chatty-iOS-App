//
//  GrayBackGroundTextField.swift
//  SharedDesignSystem
//
//  Created by 윤지호 on 4/4/24.
//

import UIKit
import RxCocoa
import SnapKit
import Then

open class PaddingTextField: BaseView, InputReceivable {
  // MARK: - View Property
  public let textField: UITextField = UITextField()
  
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
      $0.horizontalEdges.equalToSuperview().inset(16)
      $0.verticalEdges.equalToSuperview()
    }
  }
}

extension PaddingTextField: UITextFieldDelegate {
  public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let currentText = textField.text, let range = Range(range, in: currentText) else { return true }
    let updatedText = currentText.replacingCharacters(in: range, with: string)
    guard maxTextLength >= updatedText.count else { return false }
    inputEventRelay.accept(updatedText)
    
    return true
  }
}
