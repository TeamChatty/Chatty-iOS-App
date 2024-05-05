//
//  DetailContentSectionView.swift
//  FeatureFeed
//
//  Created by 윤지호 on 5/3/24.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import SharedDesignSystem
import DomainCommunityInterface

final class DetailContentSectionView: BaseView, Touchable {
  // MARK: - View Property
  private let contentLabel: UILabel = UILabel().then {
    $0.textAlignment = .left
    $0.numberOfLines = 0
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.body03.font
    $0.sizeToFit()
  }
  
  private let imagesButton: FeedImagesButton = FeedImagesButton().then {
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  
  // MARK: - UIConfigurable
  override func configureUI() {
    setupContentSection()
  }
  
  // MARK: - UIBindable
  override func bind() {
    imagesButton.touchEventRelay
      .map { TouchEventType.images }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension DetailContentSectionView {
  enum TouchEventType {
    case images
  }
}

extension DetailContentSectionView {
  private func setupContentSection() {
    addSubview(contentLabel)
    addSubview(imagesButton)
    
    contentLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.horizontalEdges.equalToSuperview()
      $0.height.greaterThanOrEqualTo(20)
    }
    
    imagesButton.snp.makeConstraints {
      $0.top.equalTo(contentLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(1)
      $0.bottom.equalToSuperview()
    }
  }
  
  private func updateImagesButton(isEmptyImage: Bool) {
    if isEmptyImage == false {
      let imagesButtonHeight = (CGRect.appFrame.width - 40) / 2
      imagesButton.snp.remakeConstraints {
        $0.top.equalTo(contentLabel.snp.bottom).offset(8)
        $0.horizontalEdges.equalToSuperview()
        $0.height.equalTo(imagesButtonHeight)
        $0.bottom.equalToSuperview()
      }
    }
  }
}

extension DetailContentSectionView {
  func setData(feedData: Feed) {
    imagesButton.updateImageViews(images: feedData.postImages)
    updateImagesButton(isEmptyImage: feedData.postImages.isEmpty)
    
    contentLabel.text = feedData.content
  }
}
