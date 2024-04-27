//
//  ChatRoomAnnounceView.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 19.04.2024.
//

import UIKit
import Then
import SnapKit
import SharedDesignSystem

public final class ChatRoomAnnounceView: BaseView {
  private let iconView: UIImageView = UIImageView().then {
    $0.image = UIImage(asset: Images.smallMegaphone)
    $0.contentMode = .scaleAspectFit
  }
  private let contentLabel: UILabel = UILabel().then {
    $0.font = SystemFont.caption02.font
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.text = "상대방이 궁금하면 언제든지 프로필을 눌러보세요"
  }
  
  public override func configureUI() {
    super.configureUI()
    
    self.backgroundColor = SystemColor.basicWhite.uiColor
    self.layer.cornerRadius = 8
    
    addSubview(iconView)
    iconView.snp.makeConstraints {
      $0.size.equalTo(18)
      $0.leading.equalToSuperview().offset(14)
      $0.centerY.equalToSuperview()
    }
    
    addSubview(contentLabel)
    contentLabel.snp.makeConstraints {
      $0.leading.equalTo(iconView.snp.trailing).offset(8)
      $0.centerY.equalToSuperview()
      $0.trailing.greaterThanOrEqualToSuperview().offset(-14)
    }
    
    setShadow()
  }
  
  func setShadow() {
    self.layer.shadowColor = SystemColor.basicBlack.uiColor.cgColor
    self.layer.shadowOpacity = 0.2
    self.layer.shadowRadius = 0.5
    self.layer.shadowOffset = CGSize(width: 0, height: 0.3)
    self.layer.shadowPath = nil
  }
}
