//
//  WriteFeedButton.swift
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

public class WriteFeedButton: BaseControl, Touchable, Highlightable {
  // MARK: - View Property
  
//  private let boxView: UIView = UIView()
  private let imageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = Images.plus.image.withRenderingMode(.alwaysTemplate)
    $0.tintColor = SystemColor.basicWhite.uiColor
  }
  private let titleLabel: UILabel = UILabel().then {
    $0.text = "글쓰기"
    $0.textColor = SystemColor.basicWhite.uiColor
    $0.font = SystemFont.title03.font
  }
  
  // MARK: - Rx Property
  public let touchEventRelay: PublishRelay<Void> = .init()
  
  // MARK: - Initialize Method
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  open override func bind() {
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
  
  open override func configureUI() {
    setupContentView()
  }
  
  private func setupContentView() {
//    addSubview(boxView)
    addSubview(imageView)
    addSubview(titleLabel)

//    boxView.snp.makeConstraints {
//      $0.width.equalTo(96)
//      $0.height.equalTo(43)
//      $0.centerY.centerX.equalToSuperview()
//    }
    imageView.snp.makeConstraints {
      $0.height.equalTo(24)
      $0.leading.equalToSuperview().inset(12)
      $0.centerY.equalToSuperview()
    }
    titleLabel.snp.makeConstraints {
      $0.height.equalTo(24)
      $0.leading.equalTo(imageView.snp.trailing).offset(2)
      $0.centerY.equalToSuperview()
    }
  }
}

