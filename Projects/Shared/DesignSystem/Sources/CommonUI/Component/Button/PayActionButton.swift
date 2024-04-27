//
//  PayActionButton.swift
//  SharedDesignSystem
//
//  Created by HUNHIE LEE on 15.04.2024.
//

import UIKit
import Then
import SnapKit

public class PayActionButton: FillButton {
  private let paymentIconImageView: UIImageView = UIImageView().then {
    $0.tintColor = SystemColor.basicWhite.uiColor
    $0.contentMode = .scaleAspectFill
  }
  
  private let paymentAmountLabel: UILabel = UILabel().then {
    $0.font = SystemFont.caption01.font
    $0.textColor = SystemColor.basicWhite.uiColor
  }
  
  public var paymentIconImage: UIImage? {
    didSet {
      paymentIconImageView.image = paymentIconImage
    }
  }
  
  public var paymentAmountValue: Int? {
    didSet {
      guard let paymentAmountValue else { return }
      paymentAmountLabel.text = "\(paymentAmountValue)"
    }
  }
  
  public override func configureUI() {
    super.configureUI()
    
    addSubview(paymentIconImageView)
    paymentIconImageView.snp.makeConstraints {
      $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
      $0.centerY.equalToSuperview()
    }
    
    addSubview(paymentAmountLabel)
    paymentAmountLabel.snp.makeConstraints {
      $0.leading.equalTo(paymentIconImageView.snp.trailing).offset(6)
      $0.centerY.equalToSuperview()
    }
  }
}
