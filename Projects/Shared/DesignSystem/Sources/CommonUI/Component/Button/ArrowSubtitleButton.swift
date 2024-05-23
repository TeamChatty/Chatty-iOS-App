//
//  ArrowSubtitleButton.swift
//  FeatureProfile
//
//  Created by 윤지호 on 3/24/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

public final class ArrowSubtitleButton: BaseControl, Touchable, Highlightable, Transformable {
  // MARK: - View Property
  private let titleLabel: UILabel = UILabel().then {
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.body02.font
  }
 
  private let contentLabel: UILabel = UILabel().then {
    $0.textAlignment = .left
  }
  private let arrowImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = Images.vArrowRight.image.withRenderingMode(.alwaysTemplate)
    $0.tintColor = SystemColor.gray500.uiColor
  }
  
  // MARK: - Stored Property
  public var title: String? {
    didSet {
      self.titleLabel.text = title
    }
  }
  
  public var contentText: String? {
    didSet {
      setStateForContentText()
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
    self.layer.cornerRadius = 8
    self.layer.borderWidth = 1
    self.layer.borderColor = SystemColor.gray200.uiColor.cgColor
    
    addSubview(titleLabel)
    addSubview(contentLabel)
    addSubview(arrowImageView)
    
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.height.equalTo(20)
      $0.leading.equalToSuperview().inset(16)
    }
    
    arrowImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.height.width.equalTo(24)
      $0.trailing.equalToSuperview().inset(12)
    }
    
    contentLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.height.equalTo(24)
      $0.trailing.equalTo(arrowImageView.snp.leading).offset(-12)
    }
  }
  
  // MARK: - UIBindable
  public override func bind() {
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
}
extension ArrowSubtitleButton: StateConfigurable {
  public enum State {
    case validData
    case emptyData
  }
  
  public struct Configuration {
    var contentText: String
    let font: UIFont
    let textColor: UIColor
    
    public init(contentText: String = "지역 입력하면 +10%", font: UIFont, textColor: UIColor) {
      self.contentText = contentText
      self.font = font
      self.textColor = textColor
    }
  }
  
  public func updateForCurrentState() {
    guard let currentState,
          let config = configurations[currentState] else { return }
    
    contentLabel.text = config.contentText
    contentLabel.font = config.font
    contentLabel.textColor = config.textColor
    self.isEnabled = true
  }
  
  private func setStateForContentText() {
    if let contentText {
      let validData = Configuration(
        contentText: contentText,
        font: SystemFont.body01.font,
        textColor: SystemColor.basicBlack.uiColor
      )
      setState(validData, for: .validData)
      currentState = .validData
    } else {
      currentState = .emptyData
    }
  }
}


