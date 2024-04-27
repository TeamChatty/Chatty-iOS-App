//
//  AddImageButton.swift
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

final class AddImageButton: BaseControl, Highlightable, Touchable {
  // MARK: - View Property
  private let plusImageview: UIImageView = UIImageView().then {
    let image = Images.smallPlus.image.resize(newWidth: 18).withRenderingMode(.alwaysTemplate)
    $0.tintColor = SystemColor.basicWhite.uiColor
    $0.image = image
    
    $0.contentMode = .center
    $0.backgroundColor = SystemColor.gray400.uiColor
    $0.layer.cornerRadius = 24 / 2
    $0.clipsToBounds = true
  }
  
  private let addimageLabel: UILabel = UILabel().then {
    $0.text = "사진 추가"
    $0.textAlignment = .center
    $0.textColor = SystemColor.gray400.uiColor
    $0.font = SystemFont.caption03.font
    $0.numberOfLines = 1
  }
  private let imageCountLabel: UILabel = UILabel().then {
    $0.text = "0/5"
    $0.numberOfLines = 1
    $0.textAlignment = .center
    $0.textColor = SystemColor.gray400.uiColor
    $0.font = SystemFont.caption03.font
  }

  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<Void> = .init()

  
  // MARK: - UIConfigurable
  override func configureUI() {
    addSubview(addimageLabel)
    addSubview(imageCountLabel)
    addSubview(plusImageview)

    addimageLabel.snp.makeConstraints {
      $0.height.equalTo(14)
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(16)
    }
    
    imageCountLabel.snp.makeConstraints {
      $0.height.equalTo(14)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(addimageLabel.snp.bottom).offset(2)
    }
    
    plusImageview.snp.makeConstraints {
      $0.height.width.equalTo(24)
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(addimageLabel.snp.top).offset(-6)
    }
  }
  
  // MARK: - UIBindable
  override func bind() {
    self.rx.controlEvent(.touchDown)
      .bind(with: self) { [weak self] owner, _ in
        guard let self else { return }
        owner.highlight(self)
      }
      .disposed(by: disposeBag)
    
    Observable.merge(
        self.rx.controlEvent(.touchDragExit).map { _ in Void() },
        self.rx.controlEvent(.touchCancel).map { _ in Void() }
    )
    .bind(with: self) { [weak self] _, _  in
      guard let self else { return }
      self.unhighlight(self)
    }
    .disposed(by: disposeBag)
    
    self.rx.controlEvent(.touchUpInside)
      .map { _ in Void() }
      .do { [weak self] _ in
        guard let self else { return }
        self.unhighlight(self)
      }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension AddImageButton {
  func updateLabelCount(imageCount: Int) {
    self.imageCountLabel.text = "\(imageCount)/5"
  }
}
