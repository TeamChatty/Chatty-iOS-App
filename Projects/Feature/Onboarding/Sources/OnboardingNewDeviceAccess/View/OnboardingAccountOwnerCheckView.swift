//
//  OnboardingAccountOwnerCheckView.swift
//  FeatureOnboardingInterface
//
//  Created by HUNHIE LEE on 1/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SharedDesignSystem

final class OnboardingAccountOwnerCheckView: BaseView, Touchable {
  // MARK: - View Property
  private let profileTitleContainer: UIView = UIView()
  
  private let profileImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.clipsToBounds = true
    $0.backgroundColor = .gray
  }
  
  private let titleLabel: UILabel = UILabel().then {
    $0.text = "이 번호로 등록된 계정이 있어요!"
    $0.font = SystemFont.title02.font
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.textAlignment = .center
  }
  
  private let subTitleLabel: UILabel = UILabel().then {
    $0.text = "이 계정의 주인인가요?"
    $0.font = SystemFont.caption02.font
    $0.textColor = SystemColor.gray600.uiColor
    $0.textAlignment = .center
  }
  
  private let guideLabel: UILabel = UILabel().then {
    $0.textAlignment = .center
    
    let attributedString = NSMutableAttributedString(string: "가입한 적이 없으신가요?")
    attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
    $0.attributedText = attributedString
    $0.font = SystemFont.caption02.font
    $0.textColor = SystemColor.gray600.uiColor
  }
  
  private let ownedAccountButton: FillButton = FillButton().then {
    typealias Config = FillButton.Configuration
    let config = Config(backgroundColor: SystemColor.primaryNormal.uiColor, isEnabled: true)
    
    $0.title = "제가 이 계정 주인이에요"
    $0.setState(config, for: .enabled)
    $0.currentState = .enabled
    $0.cornerRadius = 8
  }
  
  private let createAccountButton: FillButton = FillButton().then {
    typealias Config = FillButton.Configuration
    let config = Config(backgroundColor: SystemColor.primaryLight.uiColor, textColor: SystemColor.primaryNormal.uiColor, isEnabled: true)
    
    $0.title = "새 계정 만들기"
    $0.setState(config, for: .enabled)
    $0.currentState = .enabled
    $0.cornerRadius = 8
  }
  
  // MARK: - Rx Property
  private let disposeBag: DisposeBag = DisposeBag()
  
  // MARK: - Touchable
  public var touchEventRelay: PublishRelay<TouchEventType> = .init()
  
  public var profileImageURL: String? {
    didSet {
      if let profileImageURL,
         let source = URL(string: profileImageURL) {
        profileImageView.kf.setImage(with: source)
      } else {
        profileImageView.image = UIImage(asset: Images.boyGray)
      }
    }
  }
  
  override func configureUI() {
    setupProfileTitleContainer()
    setupCreateAccountButton()
    setupOwnedAccountButton()
    setupGuidLabel()
  }
  
  override func bind() {
    ownedAccountButton.touchEventRelay
      .map { .ownedAccount }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    createAccountButton.touchEventRelay
      .map { .createAccount }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
  
  private func setupProfileTitleContainer() {
    addSubview(profileTitleContainer)
    profileTitleContainer.addSubview(profileImageView)
    profileTitleContainer.addSubview(titleLabel)
    profileTitleContainer.addSubview(subTitleLabel)
    
    profileTitleContainer.snp.makeConstraints {
      $0.centerY.equalToSuperview().offset(-116)
      $0.centerX.equalToSuperview()
    }
    
    profileImageView.snp.makeConstraints {
      $0.top.centerX.equalToSuperview()
      $0.size.equalTo(160)
    }
    
    profileImageView.makeCircle(with: 160)
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.bottom).offset(20)
      $0.horizontalEdges.equalToSuperview()
    }
    
    subTitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
  
  private func setupCreateAccountButton() {
    addSubview(createAccountButton)
    createAccountButton.snp.makeConstraints {
      $0.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(52)
    }
  }
  
  private func setupOwnedAccountButton() {
    addSubview(ownedAccountButton)
    ownedAccountButton.snp.makeConstraints {
      $0.bottom.equalTo(createAccountButton.snp.top).offset(-8)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(52)
    }
  }
  
  private func setupGuidLabel() {
    addSubview(guideLabel)
    guideLabel.snp.makeConstraints {
      $0.bottom.equalTo(ownedAccountButton.snp.top).offset(-12)
      $0.centerX.equalToSuperview()
    }
  }
}

extension OnboardingAccountOwnerCheckView {
  enum TouchEventType {
    case ownedAccount
    case createAccount
  }
}
