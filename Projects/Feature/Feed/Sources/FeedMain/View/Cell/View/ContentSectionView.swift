//
//  ContentSectionView.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/19/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import SharedDesignSystem
import DomainCommunityInterface

final class ContentSectionView: BaseView, Touchable {
  // MARK: - View Property
  private let contentLabel: UILabel = UILabel().then {
    $0.textAlignment = .left
    $0.numberOfLines = 3
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.body03.font
    $0.sizeToFit()
  }
  private let moreContentButton: TextButton = TextButton().then {
    $0.title = "...더보기"
    $0.textAlignment = .left
    $0.tintColor = SystemColor.gray600.uiColor
    $0.font = SystemFont.body03.font
    $0.backgroundColor = .clear
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
    moreContentButton.touchEventRelay
      .map { TouchEventType.moreDetail }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    imagesButton.touchEventRelay
      .map { TouchEventType.moreDetail }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension ContentSectionView {
  enum TouchEventType {
    case moreDetail
  }
}

extension ContentSectionView {
  private func setupContentSection() {
    addSubview(contentLabel)
    addSubview(moreContentButton)
    addSubview(imagesButton)
    
    contentLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.horizontalEdges.equalToSuperview()
      $0.height.greaterThanOrEqualTo(20)
    }
    moreContentButton.snp.makeConstraints {
      $0.top.equalTo(contentLabel.snp.bottom)
      $0.trailing.equalTo(contentLabel.snp.trailing)
      $0.height.equalTo(20)
    }
    
    imagesButton.snp.makeConstraints {
      $0.top.equalTo(moreContentButton.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(1)
      $0.bottom.equalToSuperview()
    }
  }
  
  private func updateImagesButton(isEmptyImage: Bool) {
    if isEmptyImage == false {
      moreContentButton.snp.remakeConstraints {
        $0.top.equalTo(contentLabel.snp.bottom)
        $0.trailing.equalTo(contentLabel.snp.trailing)
        $0.height.equalTo(20)
      }
      
      let imagesButtonHeight = (CGRect.appFrame.width - 40) / 2
      imagesButton.snp.remakeConstraints {
        $0.top.equalTo(moreContentButton.snp.bottom).offset(8)
        $0.horizontalEdges.equalToSuperview()
        $0.height.equalTo(imagesButtonHeight)
        $0.bottom.equalToSuperview()
      }
    }
  }
}

extension ContentSectionView {
  func setData(feedData: Feed) {
    var images: [String] = []

    if feedData.postId == 1 {
      images = [
        "https://chatty-dev-s3.s3.ap-northeast-2.amazonaws.com/profile/29.jpg",
        "https://chatty-dev-s3.s3.ap-northeast-2.amazonaws.com/profile/29.jpg",
        "https://chatty-dev-s3.s3.ap-northeast-2.amazonaws.com/profile/29.jpg",
        "https://chatty-dev-s3.s3.ap-northeast-2.amazonaws.com/profile/29.jpg",
      ]
      imagesButton.updateImageViews(images: images)

    } else if feedData.postId == 0 {
      images = [
        "https://chatty-dev-s3.s3.ap-northeast-2.amazonaws.com/profile/29.jpg",
        "https://chatty-dev-s3.s3.ap-northeast-2.amazonaws.com/profile/29.jpg",
      ]
      imagesButton.updateImageViews(images: images)

    }
    updateImagesButton(isEmptyImage: images.isEmpty)
    contentLabel.text = feedData.content
  }
  
  func reuseView() {
    imagesButton.snp.removeConstraints()
    
    moreContentButton.snp.remakeConstraints {
      $0.top.equalTo(contentLabel.snp.bottom)
      $0.trailing.equalTo(contentLabel.snp.trailing)
      $0.height.equalTo(20)
      $0.bottom.equalToSuperview()
    }
    
    imagesButton.reuseView()
  }
}
