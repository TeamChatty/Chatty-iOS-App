//
//  FeedProfileSegmentView.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/26/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

import SharedDesignSystem

final class FeedProfileSegmentView: BaseView, Touchable {
  // MARK: - View Property
  private let writedFeedButton: FillButton = FillButton().then {
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
  private let myCommentButton: FillButton = FillButton().then {
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
  private let savedFeedButton: FillButton = FillButton().then {
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
    writedFeedButton.touchEventRelay
      .map { _ in 0 }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    myCommentButton.touchEventRelay
      .map { _ in 1 }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    savedFeedButton.touchEventRelay
      .map { _ in 2 }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension FeedProfileSegmentView {
  private func setupButtons() {
    addSubview(writedFeedButton)
    addSubview(myCommentButton)
    addSubview(savedFeedButton)
    
    writedFeedButton.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().inset(20)
      $0.width.equalToSuperview().inset(7).dividedBy(3)
      $0.bottom.equalToSuperview().inset(4)
    }
    
    myCommentButton.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalTo(writedFeedButton.snp.trailing)
      $0.width.equalToSuperview().inset(7).dividedBy(3)
      $0.bottom.equalToSuperview().inset(4)
    }
    
    savedFeedButton.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.trailing.equalToSuperview().inset(20)
      $0.width.equalToSuperview().inset(7).dividedBy(3)
      $0.bottom.equalToSuperview().inset(4)
    }
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
      $0.centerX.width.equalTo(writedFeedButton)
    }
  }
  
  private func updateBottomBar(_ index: Int) {
    switch index {
    case 0:
      bottomBar.snp.remakeConstraints {
        $0.bottom.equalToSuperview()
        $0.height.equalTo(4)
        $0.centerX.width.equalTo(writedFeedButton)
      }
    case 1:
      bottomBar.snp.remakeConstraints {
        $0.bottom.equalToSuperview()
        $0.height.equalTo(4)
        $0.centerX.width.equalTo(myCommentButton)
      }
    default:
      bottomBar.snp.remakeConstraints {
        $0.bottom.equalToSuperview()
        $0.height.equalTo(4)
        $0.centerX.width.equalTo(savedFeedButton)
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

extension FeedProfileSegmentView {
  func setIndex(_ index: Int) {
    writedFeedButton.currentState = index == 0 ? .disabled : .enabled
    myCommentButton.currentState = index == 1 ? .disabled : .enabled
    savedFeedButton.currentState = index == 2 ? .disabled : .enabled
    self.pageIndex = index
    updateBottomBar(index)
  }
}

