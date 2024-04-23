//
//  AddImageScrollView.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/20/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

import SharedDesignSystem

final class AddImageScrollView: BaseView, Touchable {
  // MARK: - View Property
  private let scrollView: UIScrollView = UIScrollView().then {
    $0.isScrollEnabled = true
  }
  private let mainStackView: UIStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .leading
    $0.spacing = 12
  }
  private let addedImageStackView: UIStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .leading
    $0.spacing = 12
    
    $0.layoutIfNeeded()
  }
  private let addImageButton: AddImageButton = AddImageButton().then {
    $0.backgroundColor = .white
    $0.layer.borderWidth = 1
    $0.layer.borderColor = SystemColor.gray300.uiColor.cgColor
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  
  
  // MARK: - UIConfigurable
  override func configureUI() {
    setScrollView()
    setMainStackView()
  }
  
  // MARK: - UIBindable
  override func bind() {
    addImageButton.touchEventRelay
      .map { TouchEventType.addImage }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension AddImageScrollView {
  private func setScrollView() {
    
    addSubview(scrollView)
    scrollView.addSubview(mainStackView)
    
    scrollView.snp.makeConstraints {
      $0.horizontalEdges.verticalEdges.equalToSuperview()
    }
    
    mainStackView.snp.makeConstraints {
      $0.top.equalTo(scrollView.frameLayoutGuide.snp.top)
      $0.bottom.equalTo(scrollView.frameLayoutGuide.snp.bottom)
      $0.height.equalTo(scrollView.frameLayoutGuide.snp.height)
      
      $0.leading.equalTo(scrollView.contentLayoutGuide.snp.leading)
      $0.trailing.equalTo(scrollView.contentLayoutGuide.snp.trailing)
    }
  }
  
  private func setMainStackView() {
    mainStackView.addArrangedSubview(addedImageStackView)
    mainStackView.addArrangedSubview(addImageButton)
    
    addedImageStackView.snp.makeConstraints {
      $0.verticalEdges.equalToSuperview()
    }
    
    addImageButton.snp.makeConstraints {
      $0.width.height.equalTo(90)
    }
    
    let view = AddedImageView(image: nil, imageId: nil)
    addedImageStackView.addArrangedSubview(view)
    view.snp.makeConstraints {
      $0.height.equalTo(90)
      $0.width.equalTo(1)
    }
  }
}

extension AddImageScrollView {
  
}

extension AddImageScrollView {
  enum TouchEventType {
    case addImage
    case removeImage(identifier: String)
  }
}

extension AddImageScrollView {
  func updateAddedImages(images: [AddedImage]) {
    for image in images {
      let addedImageView = AddedImageView(image: image.image, imageId: image.id)
      addedImageView.layer.cornerRadius = 8
      addedImageView.clipsToBounds = true
      
      addedImageStackView.addArrangedSubview(addedImageView)
      addedImageView.snp.makeConstraints {
        $0.width.height.equalTo(90)
      }
      
      addedImageView.touchEventRelay
        .map { imageId in
          return TouchEventType.removeImage(identifier: imageId)
        }
        .bind(to: touchEventRelay)
        .disposed(by: disposeBag)
    }
  }
  
  func updateAddedImagesCount(count: Int) {
    addImageButton.updateLabelCount(imageCount: count)
  }
  
  func updateRemovedImage(imageId: String) {
    guard let arrangedSubviews = addedImageStackView.arrangedSubviews as? [AddedImageView],
          let index = arrangedSubviews.firstIndex(where: { $0.imageId == imageId }) else { return }
 
    arrangedSubviews[index].removeFromSuperview()
  }
}

