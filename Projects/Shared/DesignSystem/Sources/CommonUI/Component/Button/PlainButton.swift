//
//  PlainButton.swift
//  SharedDesignSystem
//
//  Created by walkerhilla on 1/9/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

open class PlainButton: BaseControl, Touchable, Highlightable {
  // MARK: - View Property
  private let titleLabel: UILabel = UILabel().then {
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.body03.font
    $0.textAlignment = .center
  }
  
  // MARK: - Stored Property
  public var title: String? {
    didSet {
      titleLabel.text = title
    }
  }
  
  public var textColor: UIColor? {
    didSet {
      titleLabel.textColor = textColor
    }
  }
  
  public var font: UIFont? {
    didSet {
      titleLabel.font = font
    }
  }
  
  public var textAlignment: NSTextAlignment? {
    didSet {
      if let textAlignment {
        titleLabel.textAlignment = textAlignment
      }
    }
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
    setupTitleLabel()
  }
  
  private func setupTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.centerY.equalToSuperview()
    }
  }
}
