//
//  MatchModeModalView.swift
//  FeatureLive
//
//  Created by 윤지호 on 3/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import SharedDesignSystem

final class MatchModeModalView: BaseView {
  // MARK: - View Property
  private let titleLabel: UILabel = UILabel().then {
    $0.text = "대화 모드 선택"
    $0.font = SystemFont.title02.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  
  private let subtitleLabel: UILabel = UILabel().then {
    $0.text = "매칭 성공 시 아이템이 차감돼요."
    $0.font = SystemFont.body01.font
    $0.textColor = SystemColor.gray600.uiColor
  }
  
  private let cancelButton: CancelButton = CancelButton()
  
  private let profileAuthenticationView: ProfileAuthenticationToggleView = ProfileAuthenticationToggleView()
  
  private let nomalModeButton: MatchModeButton = MatchModeButton().then {
    $0.setButtonType(.nomalMode)
  }
  
  private let fastModeButton: MatchModeButton = MatchModeButton().then {
    $0.setButtonType(.fastMode)
  }

  // MARK: - Rx Property
  private let disposeBag = DisposeBag()

  // MARK: - Touchable Property
  let touchEventRelay: PublishRelay<TouchEventType> = .init()
  
  // MARK: - UIConfigurable
  override func configureUI() {
    setupView()
    setupProfileAuthenticationView()
    setupModelButtons()
  }
  
  // MARK: - UIBindable
  override func bind() {
    cancelButton.touchEventRelay
      .map { _ in TouchEventType.cancel }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    profileAuthenticationView.touchEventRelay
      .map { bool in TouchEventType.toggle(bool) }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    nomalModeButton.touchEventRelay
      .map { _ in TouchEventType.matchMode(.nomalMode) }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    fastModeButton.touchEventRelay
      .map { _ in TouchEventType.matchMode(.fastMode) }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension MatchModeModalView: Touchable {
  enum TouchEventType {
    case cancel
    case toggle(Bool)
    case matchMode(MatchMode)
  }
}

extension MatchModeModalView {
  private func setupView() {
    addSubview(titleLabel)
    addSubview(subtitleLabel)
    addSubview(cancelButton)
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(32)
      $0.leading.equalToSuperview().inset(20)
      $0.height.equalTo(22)
    }
    
    subtitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(16)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.height.equalTo(20)
    }
    
    cancelButton.snp.makeConstraints {
      $0.size.equalTo(24)
      $0.trailing.equalToSuperview().inset(20)
      $0.centerY.equalTo(titleLabel.snp.centerY)
    }
  }
  
  private func setupProfileAuthenticationView() {
    addSubview(profileAuthenticationView)
    
    profileAuthenticationView.snp.makeConstraints {
      $0.top.equalTo(subtitleLabel.snp.bottom).offset(20)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(52)
    }
  }
  
  private func setupModelButtons() {
    let viewSize = (CGRect.appFrame.width - 60) / 2
    
    addSubview(nomalModeButton)
    addSubview(fastModeButton)
    
    nomalModeButton.snp.makeConstraints {
      $0.top.equalTo(profileAuthenticationView.snp.bottom).offset(20)
      $0.leading.equalToSuperview().inset(20)
      $0.width.height.equalTo(viewSize)
      $0.bottom.equalToSuperview().inset(46)
    }
    
    fastModeButton.snp.makeConstraints {
      $0.top.equalTo(nomalModeButton.snp.top)
      $0.trailing.equalToSuperview().inset(20)
      $0.height.width.equalTo(viewSize)
      $0.bottom.equalToSuperview().inset(46)
    }
  }
}
