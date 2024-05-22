//
//  HeaderSecionView.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/19/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import SharedUtil
import SharedDesignSystem
import DomainCommunityInterface

final class HeaderSecionView: BaseView, Touchable {
  // MARK: - View Property
  private let profileImageView: ChangeableImageButton = ChangeableImageButton().then {
    $0.imageView.contentMode = .scaleAspectFit
    $0.layer.cornerRadius = 36 / 2
    $0.clipsToBounds = true
    $0.backgroundColor = .gray
  }
//  private let profileImageView2: UIImageView = UIImageView().then {
//    $0.contentMode = .scaleAspectFit
//    $0.layer.cornerRadius = 36 / 2
//    $0.clipsToBounds = true
//    $0.backgroundColor = .gray
//  }
  private let nicknameLabel: UILabel = UILabel().then {
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.body02.font
  }
  private let timeLabel: UILabel = UILabel().then {
    $0.textColor = SystemColor.gray600.uiColor
    $0.font = SystemFont.caption03.font
  }
  private let reportButton: ChangeableImageButton = ChangeableImageButton().then {
    typealias Config = ChangeableImageButton.Configuration
    let image = Images._3DotHorizontal.image.withRenderingMode(.alwaysTemplate)
    let enabled = Config(image: image, tintColor: SystemColor.basicBlack.uiColor, isEnabled: true)
    let disabled = Config(image: UIImage(), tintColor: SystemColor.basicWhite.uiColor, isEnabled: false)
    
    $0.setState(enabled, for: .enabled)
    $0.setState(disabled, for: .disabled)
  }
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  
  // MARK: - UIConfigurable
  override func configureUI() {
    setupHeaderSection()
  }
  
  // MARK: - UIBindable
  override func bind() {
    profileImageView.touchEventRelay
      .map { TouchEventType.profileImage }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    reportButton.touchEventRelay
      .map { TouchEventType.report }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension HeaderSecionView {
  enum TouchEventType {
    case report
    case profileImage
  }
}

extension HeaderSecionView {
  private func setupHeaderSection() {
    addSubview(profileImageView)
    addSubview(nicknameLabel)
    addSubview(timeLabel)
    addSubview(reportButton)
    
    profileImageView.snp.makeConstraints {
      $0.width.equalTo(36)
      $0.verticalEdges.equalToSuperview()
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
    }
    nicknameLabel.snp.makeConstraints {
      $0.height.equalTo(20)
      $0.top.equalTo(profileImageView.snp.top)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
    }
    timeLabel.snp.makeConstraints {
      $0.height.equalTo(14)
      $0.bottom.equalTo(profileImageView.snp.bottom)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
    }
    reportButton.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.trailing.equalToSuperview()
    }
  }
}

extension HeaderSecionView {
  func setData(feedData: Feed) {
    profileImageView.imageView.setProfileImageKF(urlString: feedData.imageUrl, gender: .male, scale: .s36)
    
    if feedData.owner {
      profileImageView.isEnabled = false
    } else {
      profileImageView.isEnabled = true
    }
    
    nicknameLabel.text = feedData.nickname
    timeLabel.text = feedData.createdAt.toTimeDifference()
    
    reportButton.currentState = feedData.owner ? .disabled : .enabled
  }
}
