//
//  SettingView.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/11/24.
//

import UIKit
import DomainUserInterface
import SharedDesignSystem
import SnapKit
import Then

import RxSwift
import RxCocoa

final class SettingNotificationView: BaseView, Touchable {
  // MARK: - View Property
  private let marketingNotiSwitch: NotificationToggleButton = NotificationToggleButton().then {
    $0.title = "마케팅 알림"
    $0.subtitle = "대화하기 좋은 시간대에 알림을 받아요."
  }
  
  private let chatNotiSwitch: NotificationToggleButton = NotificationToggleButton().then {
    $0.title = "채팅 알림"
    $0.subtitle = "채팅방으로 메세지가 왔을 때 받는 알림이에요."
  }
  
  private let feedNotiSwitch: NotificationToggleButton = NotificationToggleButton().then {
    $0.title = "피드 알림"
    $0.subtitle = "피드 좋아요, 댓글 관련 알림이에요."
  }
  

  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  
  // MARK: - UIConfigurable
  override func configureUI() {
    setupView()
  }
  
  // MARK: - UIBindable
  override func bind() {
    marketingNotiSwitch.touchEventRelay
      .map { TouchEventType.marketingNoti($0) }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    chatNotiSwitch.touchEventRelay
      .map { TouchEventType.chattingNoti($0) }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    feedNotiSwitch.touchEventRelay
      .map { TouchEventType.feedNoti($0) }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension SettingNotificationView {
  enum TouchEventType {
    case marketingNoti(Bool)
    case chattingNoti(Bool)
    case feedNoti(Bool)
  }
}

extension SettingNotificationView {
  private func setupView() {
    addSubview(marketingNotiSwitch)
    addSubview(chatNotiSwitch)
    addSubview(feedNotiSwitch)
    
    marketingNotiSwitch.snp.makeConstraints {
      $0.top.equalToSuperview().inset(82)
      $0.height.equalTo(36)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    chatNotiSwitch.snp.makeConstraints {
      $0.top.equalTo(marketingNotiSwitch.snp.bottom).offset(30)
      $0.height.equalTo(36)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    feedNotiSwitch.snp.makeConstraints {
      $0.top.equalTo(chatNotiSwitch.snp.bottom).offset(30)
      $0.height.equalTo(36)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
  }
  
}

extension SettingNotificationView {
  func updateState(state :NotificationReceiveCheck) {
    marketingNotiSwitch.setSwitch(state.marketingNotification)
    chatNotiSwitch.setSwitch(state.chattingNotification)
    feedNotiSwitch.setSwitch(state.feedNotification)
  }
}

