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
  private let headerButton: ChangeableImageButton = ChangeableImageButton().then {
    typealias Configuration = ChangeableImageButton.Configuration
    let commonState = Configuration(
      image: Images.smallInformationCircle.image,
      tintColor: SystemColor.gray700.uiColor,
      size: 18,
      isEnabled: true
    )
    $0.setState(commonState, for: .customImage)
    $0.currentState = .customImage
  }
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
    $0.cornerRadius = 28 / 2
  }
  
  private let profileImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.layer.cornerRadius = 120 / 2
    $0.layer.borderWidth = 2
    $0.layer.borderColor = SystemColor.gray200.uiColor.cgColor
    $0.clipsToBounds = true
  }
  private let profileImageOpacuityLabel: UILabel = UILabel().then {
    $0.textAlignment = .center
    $0.font = SystemFont.body01.font
    $0.textColor = SystemColor.basicWhite.uiColor
  }
  
  private let cameraButton: ChangeableImageButton = ChangeableImageButton().then {
    typealias Configuration = ChangeableImageButton.Configuration
    let commonState = Configuration(
      image: Images.camera.image,
      tintColor: SystemColor.gray600.uiColor,
      backgroundColor: SystemColor.basicWhite.uiColor,
      size: 24,
      isEnabled: true
    )
    $0.setState(commonState, for: .customImage)
    $0.currentState = .customImage
    
    $0.layer.cornerRadius = 36 / 2
    $0.layer.borderColor = SystemColor.gray200.uiColor.cgColor
    $0.layer.borderWidth = 2
  }
  private let certifiedLabel: TitleImageLabel = TitleImageLabel(
    imageSize: 18,
    imagePosition: .left,
    space: 1
  ).then {
    $0.image = Images.smallShieldGray.image
    $0.font = SystemFont.body01.font
    $0.textColor = SystemColor.gray600.uiColor
  }
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  enum TouchEventType {
    case chatImageGuide
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
    headerButton.touchEventRelay
      .map { TouchEventType.chatImageGuide }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    certifiedGuideButton.touchEventRelay
      .map { TouchEventType.imageGuide }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    cameraButton.touchEventRelay
      .map { TouchEventType.selectImage }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension EditImageTableViewCell {
  func updateCell(userData: UserProfile) {
    profileImageView.setImageKF(urlString: userData.imageUrl)
    if userData.blueCheck {
      profileImageOpacuityLabel.text = ""
      profileImageOpacuityLabel.backgroundColor = .clear
      certifiedLabel.title = "인증 완료"
    } else {
      profileImageOpacuityLabel.text = "요청 중"
      profileImageOpacuityLabel.backgroundColor = .black.withAlphaComponent(0.5)

      certifiedLabel.title = "사진 미인증"
    }
  }
}

extension EditImageTableViewCell {
  private func setupTitle() {
    contentView.addSubview(headerTitle)
    contentView.addSubview(headerButton)
    contentView.addSubview(certifiedGuideButton)
    
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
    contentView.addSubview(profileImageView)
    profileImageView.addSubview(profileImageOpacuityLabel)
    contentView.addSubview(cameraButton)
    contentView.addSubview(certifiedLabel)
    
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(85)
      $0.height.width.equalTo(120)
      $0.centerX.equalToSuperview()
    }
    
    profileImageOpacuityLabel.snp.makeConstraints {
      $0.edges.equalToSuperview()
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
