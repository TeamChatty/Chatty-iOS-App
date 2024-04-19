//
//  FeedMainSegmentView.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/15/24.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

import SharedDesignSystem

final class FeedMainSegmentView: BaseView, Touchable {
  // MARK: - View Property
  private let editButton: FillButton = FillButton().then {
    typealias Configuration = FillButton.Configuration
    let selected = Configuration(
      backgroundColor: SystemColor.basicWhite.uiColor,
      textColor: SystemColor.basicBlack.uiColor,
      isEnabled: false,
      font: SystemFont.title03.font
    )
    let deselected = Configuration(
      backgroundColor: SystemColor.basicWhite.uiColor,
      textColor: SystemColor.gray400.uiColor,
      isEnabled: true,
      font: SystemFont.title03.font
    )
    
    $0.setState(selected, for: .disabled)
    $0.setState(deselected, for: .enabled)
    
    $0.title = "최신"
  }
  private let previewButton: FillButton = FillButton().then {
    typealias Configuration = FillButton.Configuration
    let selected = Configuration(
      backgroundColor: SystemColor.basicWhite.uiColor,
      textColor: SystemColor.basicBlack.uiColor,
      isEnabled: false,
      font: SystemFont.title03.font
    )
    let deselected = Configuration(
      backgroundColor: SystemColor.basicWhite.uiColor,
      textColor: SystemColor.gray400.uiColor,
      isEnabled: true,
      font: SystemFont.title03.font
    )
    
    $0.setState(selected, for: .disabled)
    $0.setState(deselected, for: .enabled)
    
    $0.title = "추천"
  }
  
  private let bottomBar: UIView = UIView().then {
    $0.backgroundColor = SystemColor.basicBlack.uiColor
  }
  
  private var pageIndex: Int = 0
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<Int> = .init()

  // MARK: - UIConfigurable
  override func configureUI() {
    setupButtons()
    setupBottomBar()
  }
  // MARK: - UIBindable
  override func bind() {
    editButton.touchEventRelay
      .map { _ in 0 }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    previewButton.touchEventRelay
      .map { _ in 1 }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension FeedMainSegmentView {
  private func setupButtons() {
    addSubview(editButton)
    addSubview(previewButton)
    
    editButton.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().inset(20)
      $0.width.equalToSuperview().inset(10).dividedBy(2)
      $0.bottom.equalToSuperview().inset(4)
    }
    
    previewButton.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.trailing.equalToSuperview().inset(20)
      $0.width.equalToSuperview().inset(10).dividedBy(2)
      $0.bottom.equalToSuperview().inset(4)
    }
    
    editButton.backgroundColor = .brown
    previewButton.backgroundColor = .blue

  }
  
  private func setupBottomBar() {
    let bottomView = UIView()
    bottomView.backgroundColor = SystemColor.gray200.uiColor
    addSubview(bottomView)
    addSubview(bottomBar)
    
    bottomView.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.bottom.horizontalEdges.equalToSuperview()
    }
    
    bottomBar.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.height.equalTo(4)
      $0.centerX.width.equalTo(editButton)
    }
  }
  
  private func updateBottomBar(_ index: Int) {
    if index == 0 {
      bottomBar.snp.remakeConstraints {
        $0.bottom.equalToSuperview()
        $0.height.equalTo(4)
        $0.centerX.width.equalTo(editButton)
      }
    } else {
      bottomBar.snp.remakeConstraints {
        $0.bottom.equalToSuperview()
        $0.height.equalTo(4)
        $0.centerX.width.equalTo(previewButton)
      }
    }
    UIView.animate(
      withDuration: 0.3,
      animations: {
        self.layoutIfNeeded()
      }
    )
  }
}

extension FeedMainSegmentView {
  func setIndex(_ index: Int) {
    editButton.currentState = index == 0 ? .disabled : .enabled
    previewButton.currentState = index == 1 ? .disabled : .enabled
    self.pageIndex = index
    updateBottomBar(index)
  }
}

