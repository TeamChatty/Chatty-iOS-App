//
//  LiveMainView.swift
//  FeatureLive
//
//  Created by 윤지호 on 2/28/24.
//

import UIKit
import RxSwift
import RxCocoa
import SharedDesignSystem

import DomainLiveInterface

final class LiveMainView: BaseView {
  // MARK: - View Property
  private let membershipButton: MatchMembershipButton = MatchMembershipButton()
  private let cashItemButtonView: MatchCashItemButton = MatchCashItemButton()
  
  private let matchBoxView: MatchBoxView = MatchBoxView()
  
  // MARK: - Rx Property
  let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  
  // MARK: - UIConfigurable
  override func configureUI() {
    super.configureUI()
    setMembershipButton()
    setItemButtonView()
    setMatchBoxView()
  }
  
  override func bind() {
    membershipButton.touchEventRelay
      .map { _ in TouchEventType.membership }
      .bind(to: self.touchEventRelay)
      .disposed(by: disposeBag)
    
    cashItemButtonView.touchEventRelay
      .map { _ in TouchEventType.cashItem }
      .bind(to: self.touchEventRelay)
      .disposed(by: disposeBag)
    
    matchBoxView.touchEventRelay
      .map { event -> TouchEventType in
        switch event {
        case .genderCondition:
          TouchEventType.genderCondition
        case .ageCondition:
          TouchEventType.ageCondition
        case .talkButton:
          TouchEventType.talkButton
        }
      }
      .bind(to: self.touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension LiveMainView: Touchable {
  enum TouchEventType {
    case membership
    case cashItem
    case genderCondition
    case ageCondition
    case talkButton
  }
}

extension LiveMainView {
  private func setMembershipButton() {
    addSubview(membershipButton)
    membershipButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(52)
      $0.leading.equalToSuperview().inset(20)
      $0.height.equalTo(36)
      $0.width.equalTo(48)
    }
    
  }
  
  private func setItemButtonView() {
    addSubview(cashItemButtonView)
    cashItemButtonView.snp.makeConstraints {
      $0.leading.equalTo(membershipButton.snp.trailing).offset(12)
      $0.centerY.equalTo(membershipButton.snp.centerY)
      $0.height.equalTo(36)
    }
  }
  
  private func setMatchBoxView() {
    addSubview(matchBoxView)
    matchBoxView.snp.makeConstraints {
      $0.bottom.horizontalEdges.equalToSuperview()
    }
  }
}

extension LiveMainView {
  func setGender(_ gender: MatchGender) {
    matchBoxView.setGenderCondition(gender)
  }
  
  func setAgeRange(_ ageRange: MatchAgeRange) {
    if ageRange.endAge == 40 {
      matchBoxView.setAgeCondition("\(ageRange.startAge) - \(ageRange.endAge)+")
    } else {
      matchBoxView.setAgeCondition("\(ageRange.startAge) - \(ageRange.endAge)")
    }
  }
}
