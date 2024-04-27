//
//  FillButton.swift
//  SharedDesignSystem
//
//  Created by walkerhilla on 12/27/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

open class FillButton: BaseControl, Touchable, Highlightable, Transformable {
  // MARK: - View Property
  public let titleLabel: UILabel = UILabel().then {
    $0.textColor = SystemColor.basicWhite.uiColor
    $0.textAlignment = .center
  }
  
  // MARK: - Stored Property
  public var title: String? {
    didSet {
      titleLabel.text = title
    }
  }
  
  public var cornerRadius: CGFloat? {
    didSet {
      guard let cornerRadius else { return }
      layer.cornerRadius = cornerRadius
    }
  }
  
  public var horizontalInset: CGFloat
  
  // MARK: - Rx Property
  public let touchEventRelay: RxRelay.PublishRelay<Void> = .init()
  
  // MARK: - StateConfigurable Property
  public var configurations: [State : Configuration] = [:]
  public var currentState: State? {
    didSet {
      updateForCurrentState()
    }
  }
  
  // MARK: - Initialize Method
  public init(horizontalInset: CGFloat = 20) {
    self.horizontalInset = horizontalInset
    super.init(frame: .zero)
  }
  
  // MARK: - UIBindable
  open override func bind() {
    self.rx.controlEvent(.touchDown)
      .bind(with: self) { [weak self] owner, _ in
        guard let self else { return }
        owner.shrink(self, duration: .fast, with: .custom(0.97))
        owner.highlight(self)
      }
      .disposed(by: disposeBag)
    
    Observable.merge(
        self.rx.controlEvent(.touchDragExit).map { _ in Void() },
        self.rx.controlEvent(.touchCancel).map { _ in Void() }
    )
    .bind(with: self) { [weak self] _, _  in
      guard let self else { return }
      self.expand(self, duration: .fast, with: .identity)
      self.unhighlight(self)
    }
    .disposed(by: disposeBag)
    
    self.rx.controlEvent(.touchUpInside)
      .map { _ in Void() }
      .do { [weak self] _ in
        guard let self else { return }
        self.expand(self, duration: .fast, with: .identity)
        self.unhighlight(self)
      }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
  
  // MARK: - UIConfigurable
  open override func configureUI() {
    setupTitleLabel()
  }
  
  private func setupTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}

extension FillButton: StateConfigurable {
  public enum State {
    case enabled
    case disabled
  }
  
  public struct Configuration {
    let backgroundColor: UIColor
    let textColor: UIColor
    let isEnabled: Bool
    let font: UIFont
    
    public init(backgroundColor: UIColor, textColor: UIColor = SystemColor.basicWhite.uiColor, isEnabled: Bool, font: UIFont = SystemFont.title03.font) {
      self.backgroundColor = backgroundColor
      self.textColor = textColor
      self.isEnabled = isEnabled
      self.font = font
    }
  }
  
  public func updateForCurrentState() {
    guard let currentState,
          let config = configurations[currentState] else { return }
    backgroundColor = config.backgroundColor
    titleLabel.textColor = config.textColor
    isEnabled = config.isEnabled
    titleLabel.font = config.font
  }
}
