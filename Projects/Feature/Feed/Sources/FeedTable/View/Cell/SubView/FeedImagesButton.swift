//
//  FeedImagesButton.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/17/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import SharedUtil

import SharedDesignSystem

class FeedImagesButton: BaseControl, Touchable {
  // MARK: - View Property
  private let divider: UIView = UIView().then {
    $0.backgroundColor = .white
  }
  private let firstImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  private let secondImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  private let blurView: UIView = UIView().then {
    $0.backgroundColor = SystemColor.basicBlack.uiColor
    
  }
  private let blurLabel: UILabel = UILabel().then {
    $0.textAlignment = .center
    $0.backgroundColor = .clear
    $0.textColor = SystemColor.basicWhite.uiColor
    $0.font = SystemFont.title02.font
  }
  
  // MARK: - Touchable
  public let touchEventRelay: RxRelay.PublishRelay<Void> = .init()
  
  // MARK: - UIBindable
  open override func bind() {
    self.rx.controlEvent(.touchUpInside)
      .map { _ in Void() }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}
extension FeedImagesButton {
  private func setupView(image: String?) {
    guard let image else { return }
    firstImageView.setImageKF(urlString: image)
    
    addSubview(firstImageView)
    firstImageView.snp.makeConstraints {
      $0.verticalEdges.horizontalEdges.equalToSuperview()
    }
  }
  
  private func setupView2(images: [String]) {
    firstImageView.setImageKF(urlString: images[0])
    secondImageView.setImageKF(urlString: images[1])
    
    addSubview(divider)
    addSubview(firstImageView)
    addSubview(secondImageView)
    
    divider.snp.makeConstraints {
      $0.centerX.verticalEdges.equalToSuperview()
      $0.width.equalTo(3)
    }
    
    firstImageView.snp.makeConstraints {
      $0.verticalEdges.leading.equalToSuperview()
      $0.trailing.equalTo(divider.snp.leading)
    }
    
    secondImageView.snp.makeConstraints {
      $0.verticalEdges.trailing.equalToSuperview()
      $0.leading.equalTo(divider.snp.trailing)
    }
  }
  
  private func setupView3(imagesCount: Int) {
    blurView.layer.opacity = 0.45
    blurLabel.text = "+ \(imagesCount)"
    
    addSubview(blurView)
    addSubview(blurLabel)
    
    blurView.snp.makeConstraints {
      $0.edges.equalTo(secondImageView)
    }
    blurLabel.snp.makeConstraints {
      $0.edges.equalTo(secondImageView)
    }
  }
}

extension FeedImagesButton {
  func updateImageViews(images: [String]) {
    switch images.count {
    case 1:
      setupView(image: images.first)
    case 2:
      setupView2(images: images)
    case 3, 4, 5:
      setupView2(images: images)
      setupView3(imagesCount: images.count - 2)
    default:
      return
    }
  }
  
  func reuseView() {
    firstImageView.image = nil
    secondImageView.image = nil
    blurLabel.text = nil
    divider.removeFromSuperview()
    firstImageView.removeFromSuperview()
    secondImageView.removeFromSuperview()
    blurView.removeFromSuperview()
    blurLabel.removeFromSuperview()
  }
}
