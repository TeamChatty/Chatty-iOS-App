//
//  EditImageTableViewCell.swift
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

final class EditImageTableViewCell: UITableViewCell, Touchable {
  static let cellId = "EditImageTableViewCell"

  // MARK: - View Property
  private let headerTitle: UILabel = UILabel().then {
    $0.text = "프로필 사진"
    $0.font = SystemFont.title03.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  private let headerButton: UIButton = UIButton()
  private let certifiedGuideButton: FillButton = FillButton().then {
    typealias Configuration = FillButton.Configuration
    let enabled = Configuration(
      backgroundColor: SystemColor.primaryLight.uiColor,
      textColor: SystemColor.primaryNormal.uiColor,
      isEnabled: true,
      font: SystemFont.caption01.font
    )
    
    $0.setState(enabled, for: .enabled)
    $0.currentState = .enabled

    $0.title = "인증가이드"
    $0.cornerRadius = 10
  }
  
  private let profileImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.layer.cornerRadius = 120 / 2
    $0.layer.borderWidth = 2
    $0.layer.borderColor = SystemColor.gray200.uiColor.cgColor
    $0.clipsToBounds = true
  }
  private let cameraButton: UIButton = UIButton()
  private let certifiedLabel: UILabel = UILabel().then {
    $0.font = SystemFont.body01.font
    $0.textColor = SystemColor.gray600.uiColor
  }
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  enum TouchEventType {
    case imageGuide
    case selectImage
  }
  
  // MARK: - Initialize Method
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UIConfigurable
  private func configureUI() {
    setupTitle()
    setupImage()
  }
  
  
  // MARK: - UIBindable
  private func bind() {
    certifiedGuideButton.touchEventRelay
      .map { TouchEventType.imageGuide }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    cameraButton.rx.tap
      .map { TouchEventType.selectImage }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension EditImageTableViewCell {
  func updateCell(userData: UserProfile) {
    profileImageView.setImageKF(urlString: userData.imageUrl)
  }
}

extension EditImageTableViewCell {
  private func setupTitle() {
    addSubview(headerTitle)
    addSubview(headerButton)
    addSubview(certifiedGuideButton)
    
    headerTitle.snp.makeConstraints {
      $0.top.equalToSuperview().inset(30)
      $0.height.equalTo(19)
      $0.leading.equalToSuperview().inset(20)
    }
    
    headerButton.snp.makeConstraints {
      $0.size.equalTo(18)
      $0.centerY.equalTo(headerTitle.snp.centerY)
      $0.leading.equalTo(headerTitle.snp.trailing).offset(4)
    }
    
    certifiedGuideButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(30)
      $0.height.equalTo(28)
      $0.trailing.equalToSuperview().inset(20)
    }
  }
  
  private func setupImage() {
    addSubview(profileImageView)
    addSubview(cameraButton)
    addSubview(certifiedLabel)
    
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(85)
      $0.height.width.equalTo(120)
      $0.centerX.equalToSuperview()
    }
    
    cameraButton.snp.makeConstraints {
      $0.size.equalTo(36)
      $0.trailing.bottom.equalTo(profileImageView)
    }
    
    certifiedLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.bottom).offset(12)
      $0.height.equalTo(20)
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().inset(48)
    }
  }
}
