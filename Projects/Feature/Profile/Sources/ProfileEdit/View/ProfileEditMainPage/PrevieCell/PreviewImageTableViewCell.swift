//
//  PreviewImageTableViewCell.swift
//  FeatureProfileInterface
//
//  Created by 윤지호 on 3/24/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

import SharedDesignSystem
import DomainUserInterface

final class PreviewImageTableViewCell: UITableViewCell {
  static let cellId = "PreviewImageTableViewCell"
  
  // MARK: - View Property
  private let profileImageView: UIImageView = UIImageView()
  private let viewBlurEffect: UIVisualEffectView = UIVisualEffectView()
  private let nameLabel: TitleImageLabel = TitleImageLabel(
    imageSize: 24,
    imagePosition: .right,
    space: 1
  ).then {
    $0.image = Images.shieldGray.image
    $0.font = SystemFont.headLine02.font
    $0.textColor = SystemColor.basicWhite.uiColor
  }
  private let ageAndGenderLabel: UILabel = UILabel().then {
    $0.font = SystemFont.title04.font
    $0.textColor = SystemColor.basicWhite.uiColor
  }
  
  // MARK: - Initialize Method
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UIConfigurable
  private func configureUI() {
    contentView.addSubview(profileImageView)
    profileImageView.addSubview(viewBlurEffect)
    
    let height = CGRect.appFrame.size.width
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(height)
      $0.bottom.equalToSuperview().inset(30)
    }
    
    viewBlurEffect.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

extension PreviewImageTableViewCell {
  func updateCell(userData: UserProfile) {
    profileImageView.setImageKF(urlString: userData.imageUrl)
    nameLabel.title = userData.nickname
    ageAndGenderLabel.text = "만 \(userData.americanAge)세 ・ \(userData.genderStringKR)"
    
    if userData.blueCheck {
      viewBlurEffect.effect = UIBlurEffect(style: .light)
    } else {
      viewBlurEffect.effect = nil
    }
  }
}
