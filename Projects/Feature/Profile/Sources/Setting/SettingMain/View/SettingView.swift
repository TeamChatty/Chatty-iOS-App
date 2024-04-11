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

final class SettingView: BaseView, Touchable {
  // MARK: - View Property
  private let notificationHeader: UILabel = UILabel().then {
    $0.text = "알림 설정"
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.body01.font
  }
  private let notificationSettingButton: TextButton = TextButton().then {
    $0.title = "알림 상세 설정"
    $0.textAlignment = .left
    $0.tintColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.body03.font
  }
  private let divider: UIView = UIView().then {
    $0.backgroundColor = SystemColor.gray100.uiColor
  }
  
  private let accountHeader: UILabel = UILabel().then {
    $0.text = "계정 설정"
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.body01.font
  }
  private let phoneNumberChangeButton: TextButton = TextButton().then {
    $0.title = "전화변호 변경"
    $0.textAlignment = .left
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.body03.font
  }
  private let logoutButton: TextButton = TextButton().then {
    $0.title = "로그아웃"
    $0.textAlignment = .left
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.body03.font
  }
  private let accountRemoveButton: TextButton = TextButton().then {
    $0.title = "계정 삭제하기"
    $0.textAlignment = .left
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.body03.font
  }

  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  
  // MARK: - UIConfigurable
  override func configureUI() {
    setupNotificationSection()
    setupAccountSection()
  }
  
  // MARK: - UIBindable
  override func bind() {
    notificationSettingButton.touchEventRelay
      .map { TouchEventType.notificationDetail }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    phoneNumberChangeButton.touchEventRelay
      .map { TouchEventType.phoneNumberChange }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    logoutButton.touchEventRelay
      .map { TouchEventType.logout }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    accountRemoveButton.touchEventRelay
      .map { TouchEventType.accountRemove }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension SettingView {
  enum TouchEventType {
    case notificationDetail
    case phoneNumberChange
    case logout
    case accountRemove
  }
}

extension SettingView {
  private func setupNotificationSection() {
    addSubview(notificationHeader)
    addSubview(notificationSettingButton)
    addSubview(divider)
    
    notificationHeader.snp.makeConstraints {
      $0.top.equalToSuperview().inset(82)
      $0.height.equalTo(17)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    notificationSettingButton.snp.makeConstraints {
      $0.top.equalTo(notificationHeader.snp.bottom).offset(15)
      $0.height.equalTo(50)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    divider.snp.makeConstraints {
      $0.top.equalTo(notificationSettingButton.snp.bottom).offset(15)
      $0.height.equalTo(1)
      $0.horizontalEdges.equalToSuperview()
    }
  }
  
  private func setupAccountSection() {
    addSubview(accountHeader)
    addSubview(phoneNumberChangeButton)
    addSubview(logoutButton)
    addSubview(accountRemoveButton)
    
    accountHeader.snp.makeConstraints {
      $0.top.equalTo(divider.snp.bottom).offset(30)
      $0.height.equalTo(17)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    phoneNumberChangeButton.snp.makeConstraints {
      $0.top.equalTo(accountHeader.snp.bottom).offset(15)
      $0.height.equalTo(50)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    logoutButton.snp.makeConstraints {
      $0.top.equalTo(phoneNumberChangeButton.snp.bottom)
      $0.height.equalTo(50)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    accountRemoveButton.snp.makeConstraints {
      $0.top.equalTo(logoutButton.snp.bottom)
      $0.height.equalTo(50)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
  }
}

