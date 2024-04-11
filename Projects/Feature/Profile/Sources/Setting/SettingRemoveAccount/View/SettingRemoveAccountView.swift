//
//  SettingView.swift
//  FeatureProfileInterface
//
//  Created by 윤지호 on 4/11/24.
//

import UIKit
import SharedDesignSystem
import SnapKit
import Then

import RxSwift
import RxCocoa

final class SettingRemoveAccountView: BaseView, Touchable {
  // MARK: - View Property
  private let headerLabel: UILabel = UILabel().then {
    $0.text = "정말 삭제하시겠어요?"
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.headLine01.font
  }
  private let descriptionLabel: VerticalAlignLabel = VerticalAlignLabel().then {
    $0.text = "계정을 삭제하면 채티에서의 모든 추억이 사라져요.\n모든 알림을 끄고 나중에 다시 돌아오는 건 어떨까요?"
    $0.tintColor = SystemColor.gray700.uiColor
    $0.font = SystemFont.title04.font
  }
  
  private let warningView: UIView = UIView().then {
    $0.backgroundColor = SystemColor.gray100.uiColor
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }
  private let warningImageView: UIImageView = UIImageView().then {
    $0.image = Images.smallInformationCircle.image.withRenderingMode(.alwaysTemplate)
    $0.tintColor = SystemColor.gray700.uiColor
    $0.contentMode = .scaleAspectFit
    $0.backgroundColor = .clear
  }
  private let warningLabel: UILabel = UILabel().then {
    $0.text = "구독 중인 멤버십은 계정 삭제 시 자동으로 해지되지 않아요.\n계정 삭제 전 구독을 취소했는지 확인해 주세요."
    $0.textAlignment = .left
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.headLine01.font
  }
  
  private let accountHeader: UILabel = UILabel().then {
    $0.text = "계정 설정"
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.body01.font
  }

  private let showSettingNotiButton: FillButton = FillButton().then {
    typealias Configuration = FillButton.Configuration
    let commonState = Configuration(
      backgroundColor: SystemColor.primaryNormal.uiColor,
      textColor: SystemColor.basicWhite.uiColor,
      isEnabled: true,
      font: SystemFont.title03.font
    )
    
    $0.title = "알림 끄러가기"
  }
  private let removeAccountButton: FillButton = FillButton().then {
    typealias Configuration = FillButton.Configuration
    let commonState = Configuration(
      backgroundColor: SystemColor.basicWhite.uiColor,
      textColor: SystemColor.basicBlack.uiColor,
      isEnabled: true,
      font: SystemFont.title03.font
    )
    
    $0.title = "서비스 탈퇴"
  }

  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  
  // MARK: - UIConfigurable
  override func configureUI() {
    setupTitleSection()
    setupButtonsSection()
    setupWarningViewSection()

  }
  
  // MARK: - UIBindable
  override func bind() {
    showSettingNotiButton.touchEventRelay
      .map { TouchEventType.showSettingNoti }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    removeAccountButton.touchEventRelay
      .map { TouchEventType.removeAccount }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
 
  }
}

extension SettingRemoveAccountView {
  enum TouchEventType {
    case showSettingNoti
    case removeAccount
  }
}

extension SettingRemoveAccountView {
  private func setupTitleSection() {
    addSubview(headerLabel)
    addSubview(descriptionLabel)
    
    headerLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(82)
      $0.height.equalTo(31)
      $0.leading.equalToSuperview().inset(20)
    }
    
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(headerLabel.snp.bottom).offset(16)
      $0.height.equalTo(44)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
  }
  
  private func setupButtonsSection() {
    addSubview(showSettingNotiButton)
    addSubview(removeAccountButton)
    
    removeAccountButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(46)
      $0.height.equalTo(52)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    showSettingNotiButton.snp.makeConstraints {
      $0.bottom.equalTo(removeAccountButton.snp.top).offset(-8)
      $0.height.equalTo(52)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
  }
  
  private func setupWarningViewSection() {
    addSubview(warningView)
    warningView.addSubview(warningImageView)
    warningView.addSubview(warningLabel)
    
    warningView.snp.makeConstraints {
      $0.bottom.equalTo(showSettingNotiButton.snp.top).offset(-24)
      $0.height.equalTo(66)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    warningImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(12)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(18)
    }
    
    warningLabel.snp.makeConstraints {
      $0.leading.equalTo(warningImageView.snp.trailing).offset(8)
      $0.trailing.equalToSuperview().inset(20)
      $0.centerY.equalToSuperview()
    }

  }
  

}

