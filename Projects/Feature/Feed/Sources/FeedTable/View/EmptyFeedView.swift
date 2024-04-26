//
//  EmptyFeedView.swift
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

final class EmptyFeedView: BaseView, Touchable {
  // MARK: - View Property
  private let noFeedImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = Images.noFeedHistory.image
  }
  private let descriptionLabel: UILabel = UILabel().then {
    $0.textColor = SystemColor.gray800.uiColor
    $0.font = SystemFont.body02.font
  }
  private let feedbutton: FillButton = FillButton(horizontalInset: 16).then {
    typealias Config = FillButton.Configuration
    let config = Config(backgroundColor: SystemColor.primaryNormal.uiColor, isEnabled: true, font: SystemFont.body01.font)

    $0.setState(config, for: .enabled)
    $0.currentState = .enabled
    $0.layer.cornerRadius = 33 / 2
  }
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<Void> = .init()
  

  // MARK: - UIConfigurable
  override func configureUI() {
    setView()
  }
  
  // MARK: - UIBindable
  override func bind() {
    feedbutton.touchEventRelay
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension EmptyFeedView {
  private func setView() {
    addSubview(descriptionLabel)
    addSubview(noFeedImageView)
    addSubview(feedbutton)
    
    descriptionLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().inset(-20)
      $0.height.equalTo(20)
    }
    
    noFeedImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.height.width.equalTo(124)
      $0.bottom.equalTo(descriptionLabel.snp.top).offset(-24)
    }
    
    feedbutton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.height.equalTo(33)
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
    }
  }
  
  func updateLadel(feedListType: FeedListType) {
    descriptionLabel.text = feedListType.description
    feedbutton.title = feedListType.buttonTitle
  }
}


