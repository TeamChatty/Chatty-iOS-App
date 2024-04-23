//
//  AddImageView.swift
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

final class AddedImageView: UIImageView, Touchable {
  // MARK: - View Property
  private let removeButtonImage: UIImageView = UIImageView().then {
    $0.image = Images.close.image.resize(newWidth: 18).withRenderingMode(.alwaysTemplate)
    $0.tintColor = SystemColor.basicWhite.uiColor
    $0.backgroundColor = SystemColor.gray800.uiColor
    $0.contentMode = .center
    $0.layer.cornerRadius = 20 / 2
  }
  
  private let removeControlArea: UIControl = UIControl()
  
  let imageId: String
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<String> = .init()
  
  init(image: UIImage?, imageId: String?) {
    if let imageId {
      self.imageId = imageId
    } else {
      self.imageId = ""
    }
    super.init(frame: .init())
    if self.imageId.isEmpty == false {
      self.image = image
      configureUI()
      bind()
      self.isUserInteractionEnabled = true
    } else {
      self.isUserInteractionEnabled = false
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UIConfigurable
  private func configureUI() {

    addSubview(removeControlArea)
    removeControlArea.addSubview(removeButtonImage)

    removeControlArea.snp.makeConstraints {
      $0.width.height.equalTo(32)
      $0.top.trailing.equalToSuperview()
    }
    
    removeButtonImage.snp.makeConstraints {
      $0.width.height.equalTo(20)
      $0.center.equalToSuperview()
    }
  }
  
  // MARK: - UIBindable
  private func bind() {
    removeControlArea.rx.controlEvent(.touchUpInside)
      .withUnretained(self)
      .map { owner, _ in
        return owner.imageId
      }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}
