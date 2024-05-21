//
//  FeedSomeoneUserView.swift
//  FeatureFeed
//
//  Created by 윤지호 on 5/21/24.
//

import UIKit
import RxSwift
import RxCocoa
import SharedDesignSystem
import DomainUserInterface

final class FeedSomeoneUserView: BaseView {
  private let profileImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.layer.cornerRadius = 44 / 2
    $0.clipsToBounds = true
  }
  private let nicknameLable: UILabel = UILabel().then {
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.title02.font
  }
  private let bluecheckImageView: ChangeableImageButton = ChangeableImageButton().then {
    typealias Config = ChangeableImageButton.Configuration
    let enabledState = Config(image: Images.smallShieldPrimary.image, isEnabled: false)
    let disabledState = Config(image: Images.smallShieldGray.image, isEnabled: false)
    
    $0.setState(enabledState, for: .enabled)
    $0.setState(disabledState, for: .disabled)
  }
  
  override func configureUI() {
    addSubview(profileImageView)
    addSubview(nicknameLable)
    addSubview(bluecheckImageView)
    
    profileImageView.snp.makeConstraints {
      $0.height.width.equalTo(44)
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().inset(20)
    }
    
    nicknameLable.snp.makeConstraints {
      $0.height.equalTo(18)
      $0.width.greaterThanOrEqualTo(10)
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
    }
    
    bluecheckImageView.snp.makeConstraints {
      $0.height.width.equalTo(18)
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(nicknameLable.snp.trailing).offset(2)
    }
  }
}

extension FeedSomeoneUserView {
  func updateSomeoneProfile(profile: SomeoneProfile) {
    self.profileImageView.setProfileImageKF(
      urlString: profile.profile.imageUrl,
      gender: profile.profile.gender == .male ? .male : .female,
      scale: .s44
    )
    self.nicknameLable.text = profile.profile.nickname
    self.bluecheckImageView.currentState = profile.profile.blueCheck ? .enabled : .disabled
  }
}

