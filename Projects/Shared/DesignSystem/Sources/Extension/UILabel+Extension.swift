//
//  UILabel+Extension.swift
//  SharedDesignSystem
//
//  Created by 윤지호 on 4/20/24.
//

import UIKit

extension UILabel {
  public func setLineSpacing(spacing: CGFloat) {
    guard let text = text else { return }
    
    let attributeString = NSMutableAttributedString(string: text)
    let style = NSMutableParagraphStyle()
    style.lineSpacing = spacing
    attributeString.addAttribute(.paragraphStyle,
                                 value: style,
                                 range: NSRange(location: 0, length: attributeString.length))
    attributedText = attributeString
  }
}
