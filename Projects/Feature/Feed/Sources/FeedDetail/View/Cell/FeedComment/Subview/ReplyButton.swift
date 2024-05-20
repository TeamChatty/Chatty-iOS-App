//
//  ReplyButton.swift
//  FeatureFeed
//
//  Created by 윤지호 on 5/13/24.
//

import Foundation

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

import SharedDesignSystem

final class ReplyButton: BaseControl, Touchable, Highlightable {
  // MARK: - View Property
  private let titleLabel: UILabel = UILabel().then {
    $0.textColor = SystemColor.gray600.uiColor
    $0.font = SystemFont.caption02.font
  }
 
  private let arrowImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = Images.vArrowRight.image.withRenderingMode(.alwaysTemplate)
    $0.tintColor = SystemColor.gray600.uiColor
  }
  
  // MARK: - Stored Property
  public var title: String? {
    didSet {
      self.titleLabel.text = title
    }
  }
  
  // MARK: - StateConfigurable Property
  public var configurations: [State : Configuration] = [:]
  public var currentState: State? {
    didSet {
      updateForCurrentState()
    }
  }
  
  // MARK: - Touchable Property
  public var touchEventRelay: PublishRelay<Void> = .init()

  // MARK: - UIConfigurable
  public override func configureUI() {
    addSubview(titleLabel)
    addSubview(arrowImageView)
    
    titleLabel.snp.makeConstraints {
      $0.verticalEdges.equalToSuperview()
      $0.leading.equalToSuperview()
    }
    
    arrowImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.height.width.equalTo(18)
      $0.leading.equalTo(titleLabel.snp.trailing).offset(2)
    }
  }
  
  // MARK: - UIBindable
  public override func bind() {
    self.rx.controlEvent(.touchDown)
      .bind(with: self) { owner, _ in
        owner.highlight(owner)
      }
      .disposed(by: disposeBag)
    
    Observable.merge(
      self.rx.controlEvent(.touchDragExit).map { _ in Void() },
      self.rx.controlEvent(.touchCancel).map { _ in Void() }
    )
    .bind(with: self) { owner, _ in
      owner.unhighlight(owner)
    }
    .disposed(by: disposeBag)
    
    self.rx.controlEvent(.touchUpInside)
      .map { _ in Void() }
      .withUnretained(self)
      .do { owner, _ in
        self.unhighlight(owner)
      }
      .map { _ in Void() }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension ReplyButton: StateConfigurable {
  public enum State {
    case enabled
    case disabled
  }
  
  public struct Configuration {
    var arrowImage: UIImage
    
    public init(arrowImage: UIImage) {
      self.arrowImage = arrowImage.withRenderingMode(.alwaysTemplate)
    }
  }
  
  public func updateForCurrentState() {
    guard let currentState,
          let config = configurations[currentState] else { return }
    
    arrowImageView.image = config.arrowImage
    self.isEnabled = true
  }
}
