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

public class PreviewImageSectionView: BaseView, Touchable {
  
  // MARK: - View Property
  private let profileImageView: UIImageView = UIImageView().then {
    $0.isUserInteractionEnabled = true
    $0.contentMode = .scaleAspectFit
  }
  
  private let viewBlurEffect: UIVisualEffectView = UIVisualEffectView(effect: nil)
  
  private let gradientView: UIView = UIView().then {
    $0.backgroundColor = .clear
  }
  private let gradientLayer: CAGradientLayer = CAGradientLayer().then {
    $0.startPoint = CGPoint(x: 0.5, y: 0.0)
    $0.endPoint = CGPoint(x: 0.5, y: 1.0)
    
    
    let colors: [CGColor] = [
      UIColor.clear.cgColor,
      UIColor.black.cgColor,
    ]
    $0.colors = colors
    let width = CGRect.appFrame.size.width
    $0.frame = CGRect(x: 0, y: 0, width: width, height: width / 2)
  }
  
  private let nicknameLabel: TitleImageLabel = TitleImageLabel(
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
  
  private let profileUnlockButton: FillButtonTemp = FillButtonTemp(horizontalInset: 12).then {
    typealias Configuration = FillButtonTemp.Configuration
    let enabled = Configuration(
      backgroundColor: SystemColor.primaryNormal.uiColor,
      textColor: SystemColor.basicWhite.uiColor,
      isEnabled: true,
      font: SystemFont.body01.font
    )
    
    $0.setState(enabled, for: .enabled)
    $0.currentState = .enabled

    $0.title = "프로필 잠금 해제"
    $0.layer.cornerRadius = 33 / 2
  }
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  public var touchEventRelay: PublishRelay<TouchEventType> = .init()
  public enum TouchEventType {
   case unlockProfileImage
  }
  
  // MARK: - UIConfigurable
  public override func configureUI() {
    /// Set ProfileImageView
    let height = CGRect.appFrame.size.width

    addSubview(profileImageView)
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(height)
      $0.bottom.equalToSuperview().inset(30)
    }
    
    /// Set Opacity / Blur View
    viewBlurEffect.frame = CGRect(x: 0, y: 0, width: height, height: height)
    profileImageView.addSubview(viewBlurEffect)

    /// Set Gradient / Nickname View
    profileImageView.addSubview(gradientView)
    gradientView.addSubview(ageAndGenderLabel)
    gradientView.addSubview(nicknameLabel)
    
    gradientView.snp.makeConstraints {
      $0.horizontalEdges.bottom.equalTo(profileImageView)
      $0.height.equalTo(profileImageView).dividedBy(2)
    }
    ageAndGenderLabel.snp.makeConstraints {
      $0.height.equalTo(22)
      $0.leading.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(20)
    }
    nicknameLabel.snp.makeConstraints {
      $0.height.equalTo(29)
      $0.leading.equalToSuperview().inset(20)
      $0.bottom.equalTo(ageAndGenderLabel.snp.top).offset(4)
    }
  }
  
  // MARK: - UIBindable
  public override func bind() {
    profileUnlockButton.touchEventRelay
      .map { TouchEventType.unlockProfileImage }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

/// Chat - UserProfile
extension PreviewImageSectionView {
  /// Chat UserProfile 에서 사용되는 메소드입니다.
  public func updateUserPreview(profileImage: String?, nickname: String, americanAge: Int, gender: String, blueCheck: Bool, isUnlocked: Bool) {
    profileImageView.setProfileImageKF(urlString: profileImage, gender: gender == "남자" ? .male : .female, scale: .s375)
    nicknameLabel.title = nickname
    ageAndGenderLabel.text = "만 \(americanAge)세 ・ \(gender)"
    
    updateIsUnlocked(isUnlocked: isUnlocked)
  }
  
  /// Chat UserProfile 의 프로필 unlock 값으로 뷰를 업데이트 합니다.
  public func updateIsUnlocked(isUnlocked: Bool) {
    if isUnlocked {
      updateBlueCheck(blueCheck: isUnlocked)
      profileUnlockButton.removeFromSuperview()
    } else {
      updateBlueCheck(blueCheck: isUnlocked)
      gradientView.addSubview(profileUnlockButton)
      profileUnlockButton.snp.makeConstraints {
        $0.height.equalTo(33)
        $0.trailing.equalToSuperview().inset(20)
        $0.bottom.equalToSuperview().inset(31)
      }
    }
  }
}

/// MyProfile - Preview
extension PreviewImageSectionView {
  /// MyProfile Preview에서 사용되는 메소드입니다.
  /// gender - "남자" /  "여자"
  public func updateMyPreviewView(profileImage: String?, nickname: String, americanAge: Int, gender: String, blueCheck: Bool) {
    profileImageView.setProfileImageKF(urlString: profileImage, gender: gender == "남자" ? .male : .female, scale: .s375)
    nicknameLabel.title = nickname
    ageAndGenderLabel.text = "만 \(americanAge)세 ・ \(gender)"
    
    updateBlueCheck(blueCheck: blueCheck)
  }
  
  /// blueCheck 값으로 뷰를 업데이트 합니다.
  private func updateBlueCheck(blueCheck: Bool) {
    if blueCheck {
      viewBlurEffect.effect = nil
      gradientView.layer.insertSublayer(gradientLayer, at: 0)
    } else {
      let blur = UIBlurEffect(style: .regular)
      viewBlurEffect.effect = blur
      viewBlurEffect.alpha = 1
      
      gradientLayer.removeFromSuperlayer()
    }
  }
}

