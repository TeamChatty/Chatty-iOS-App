//
//  FeedChatModalView.swift
//  FeatureFeed
//
//  Created by 윤지호 on 5/20/24.
//


import UIKit
import RxSwift
import RxCocoa
import SharedDesignSystem
import DomainUserInterface

final class FeedChatModalView: BaseView, Touchable {
  // MARK: - View Property
  private let cancelButton: CancelButton = CancelButton()
  private let titleLabel: UILabel = UILabel().then {
    $0.text = "상대방과 채팅을 시작해 보세요."
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.title02.font
  }
  private let descriptionLabel: UILabel = UILabel().then {
    $0.text = "무제한으로 소통하는 채팅방이 만들어져요."
    $0.textColor = SystemColor.gray600.uiColor
    $0.font = SystemFont.body01.font
  }
 
  
  private let userProfileView: FeedSomeoneUserView = FeedSomeoneUserView().then {
    $0.backgroundColor = SystemColor.gray100.uiColor
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }
 
  private let warningImageView: UIImageView = UIImageView().then {
    $0.image = Images.informationCircle.image
    $0.contentMode = .scaleAspectFit
  }
  private let warningLabel: UILabel = UILabel().then {
    $0.text = "사진 인증 유저만 본인 사진이 있어요."
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.caption03.font
  }
 
  
  private let startChatButton: FillButton = FillButton().then {
    $0.title = "확인"
    typealias Configuration = FillButton.Configuration
    let enabledConfig = Configuration(
      backgroundColor: SystemColor.primaryNormal.uiColor,
      isEnabled: true
    )
    
    $0.title = "계속하기"
    
    $0.setState(enabledConfig, for: .enabled)
    $0.currentState = .enabled
    $0.cornerRadius = 52 / 2
  }
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()

  // MARK: - UIConfigurable
  override func configureUI() {
    setupHeader()
    setupUserProfile()
    setupWarningLabel()
    setupChangeButton()
  }
  
  // MARK: - UIBindable
  override func bind() {
    cancelButton.touchEventRelay
      .map { TouchEventType.cancel }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    
    startChatButton.touchEventRelay
      .map { TouchEventType.startChat }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension FeedChatModalView {
  enum TouchEventType {
    case cancel
    case startChat
  }
}

extension FeedChatModalView {
  private func setupHeader() {
    addSubview(titleLabel)
    addSubview(descriptionLabel)
    addSubview(cancelButton)
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(32)
      $0.leading.equalToSuperview().inset(20)
      $0.height.equalTo(22)
    }
    
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(12)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(20)
    }
    
    cancelButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(32)
      $0.size.equalTo(24)
      $0.trailing.equalToSuperview().inset(20)
    }
  }
  
  private func setupUserProfile() {
    addSubview(userProfileView)
    userProfileView.snp.makeConstraints {
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(80)
    }
    
  }
  
  private func setupWarningLabel() {
    addSubview(warningImageView)
    addSubview(warningLabel)
    
    warningImageView.snp.makeConstraints {
      $0.top.equalTo(userProfileView.snp.bottom).offset(12)
      $0.leading.equalToSuperview().inset(20)
      $0.height.width.equalTo(18)
    }
    
    warningLabel.snp.makeConstraints {
      $0.centerY.equalTo(warningImageView.snp.centerY)
      $0.leading.equalTo(warningImageView.snp.trailing).offset(2)
      $0.height.equalTo(18)
    }
  }
  
  private func setupChangeButton() {
    addSubview(startChatButton)
    startChatButton.snp.makeConstraints {
      $0.top.equalTo(warningLabel.snp.bottom).offset(32)
      $0.height.equalTo(52)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(16)
    }
  }
}

extension FeedChatModalView {
  func updateSomeoneProfile(profile: SomeoneProfile) {
    userProfileView.updateSomeoneProfile(profile: profile)
  }
}
