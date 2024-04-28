//
//  PreviewImageSectionView.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/28/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

import SharedDesignSystem
import DomainUserInterface

final class PreviewImageSectionView: BaseView, Touchable {
  
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
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  enum TouchEventType {
   
  }
  
  // MARK: - UIConfigurable
  override func configureUI() {
    addSubview(profileImageView)
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
  
  // MARK: - UIBindable
  override func bind() {
    
  }
}

extension PreviewImageSectionView {
  func updateView(userProfile: UserProfile) {
    profileImageView.setImageKF(urlString: userProfile.imageUrl)
    nameLabel.title = userProfile.nickname
    ageAndGenderLabel.text = "만 \(userProfile.americanAge)세 ・ \(userProfile.genderStringKR)"
    
    if userProfile.blueCheck {
      viewBlurEffect.effect = UIBlurEffect(style: .light)
    } else {
      viewBlurEffect.effect = nil
    }
  }
}

