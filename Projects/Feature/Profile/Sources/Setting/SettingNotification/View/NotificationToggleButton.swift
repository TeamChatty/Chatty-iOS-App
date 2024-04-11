//
//  NotificationToggleButton.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import SharedDesignSystem

final class NotificationToggleButton: BaseView, Touchable {
  // MARK: - View Property
  private let titleLabel: UILabel = UILabel().then {
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.body03.font
  }
  private let subtitleLabel: UILabel = UILabel().then {
    $0.textColor = SystemColor.gray500.uiColor
    $0.font = SystemFont.caption03.font
  }
  private let toggleButton: UISwitch = UISwitch()

  var title: String? {
    didSet {
      titleLabel.text = title
    }
  }
  
  var subtitle: String? {
    didSet {
      subtitleLabel.text = subtitle
    }
  }
  
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<Bool> = .init()

  
  // MARK: - UIConfigurable
  override func configureUI() {
    addSubview(titleLabel)
    addSubview(subtitleLabel)
    addSubview(toggleButton)
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.height.equalTo(20)
      $0.leading.equalToSuperview()
    }
    
    subtitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(2)
      $0.height.equalTo(14)
      $0.leading.equalToSuperview()
    }
    
    toggleButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.height.equalTo(48)
      $0.trailing.equalToSuperview()
    }
  }
  
  // MARK: - UIBindable
  override func bind() {
    toggleButton.rx.isOn
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension NotificationToggleButton {
  func setSwitch(_ isOn: Bool) {
    toggleButton.setOn(isOn, animated: true)
  }
}
