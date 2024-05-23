//
//  IconTitleButton.swift
//  SharedDesignSystem
//
//  Created by 윤지호 on 3/17/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

open class IconTitleButton: BaseControl, Touchable, Highlightable {
  // MARK: - View Property
  private let iconImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  private let titleLabel: UILabel = UILabel().then {
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.body02.font
    $0.textAlignment = .left
  }
  
  // MARK: - Stored Property
 
  
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
    setupIconImageView()
    setupTitleLabel()
  }
  
  private func setupIconImageView() {
    addSubview(iconImageView)
    iconImageView.snp.makeConstraints {
      $0.height.width.equalTo(24)
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().inset(20)
    }
  }
  
  private func setupTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.height.equalTo(20)
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
    }
  }
}

extension IconTitleButton {
  public func setState(image: UIImage, title: String) {
    iconImageView.image = image
    titleLabel.text = title
  }
}
