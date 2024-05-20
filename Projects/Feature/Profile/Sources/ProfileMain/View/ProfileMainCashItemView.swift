//
//  ProfileMainCashItemView.swift
//  FeatureProfileInterface
//
//  Created by 윤지호 on 3/18/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import SharedDesignSystem

final class ProfileMainCashItemsView: BaseView, Touchable {
  // MARK: - View Property
  private let possessionItemsButton: ProfileMainCashItemButton = ProfileMainCashItemButton().then {
    $0.setTitleLabel(title: "보유 아이템")
  }
  private let membershipButton: ProfileMainCashItemButton = ProfileMainCashItemButton().then {
    $0.setTitleLabel(title: "맴버십 유도 글")
  }
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  public let touchEventRelay: PublishRelay<TouchEventType> = .init()

  override func configureUI() {
    addSubview(possessionItemsButton)
    addSubview(membershipButton)
    
    possessionItemsButton.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.height.equalTo(60)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    membershipButton.snp.makeConstraints {
      $0.top.equalTo(possessionItemsButton.snp.bottom).offset(12)
      $0.height.equalTo(60)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(30)
    }
  }
  
  // MARK: - UIBindable
  override func bind() {
    possessionItemsButton.touchEventRelay
      .map { _ in TouchEventType.possessionItems }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    membershipButton.touchEventRelay
      .map { _ in TouchEventType.membership }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension ProfileMainCashItemsView {
  enum TouchEventType {
    case possessionItems
    case membership
  }
}

extension ProfileMainCashItemsView {
  func setCashItemsData(candyCount: Int, ticketCount: Int) {
    possessionItemsButton.setCashItemsData(candyCount: candyCount, ticketCount: ticketCount)
  }
}
