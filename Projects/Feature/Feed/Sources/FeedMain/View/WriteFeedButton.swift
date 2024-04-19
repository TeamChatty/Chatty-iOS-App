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
  private let contentView: TitleImageLabel = TitleImageLabel(imageSize: 24, imagePosition: .left, space: 2).then {
    $0.title = "글쓰기"
    $0.textColor = SystemColor.basicWhite.uiColor
    $0.font = SystemFont.title03.font
    
    $0.image = Images.plus.image.withRenderingMode(.alwaysTemplate)
    $0.imageViewTintColor = SystemColor.basicWhite.uiColor
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
    addSubview(contentView)
    contentView.snp.makeConstraints {
      $0.height.equalTo(24)
      $0.centerY.centerX.equalToSuperview()
    }
  }
}

