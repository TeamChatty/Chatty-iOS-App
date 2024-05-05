//
//  ToastMessageButton.swift
//  SharedDesignSystem
//
//  Created by 윤지호 on 4/29/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa


public final class ToastMessageButton: BaseView {
  // MARK: - View Property
  private let checkedImage: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  private let messageLabel: UILabel = UILabel().then {
    $0.font = SystemFont.body03.font
    $0.textColor = SystemColor.basicWhite.uiColor
  }
  
  // MARK: - UIConfigurable
  public override func configureUI() {
    addSubview(checkedImage)
    addSubview(messageLabel)
    
    checkedImage.snp.makeConstraints {
      $0.width.height.equalTo(18)
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().inset(18)
    }
    messageLabel.snp.makeConstraints {
      $0.height.equalTo(20)
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(checkedImage.snp.trailing).offset(4)
    }
  }
  
  // MARK: - UIBindable
  public override func bind() {
   
  }
  
  public func showToastMessage(message: String) {
    self.messageLabel.text = message
    self.checkedImage.image = Images.smallCheckcirlcle.image
  }
}

