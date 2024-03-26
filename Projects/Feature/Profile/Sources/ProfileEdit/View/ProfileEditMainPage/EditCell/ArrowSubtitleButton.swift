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
import SharedDesignSystem

final class ArrowSubtitleButton: BaseControl, Touchable, Highlightable, Transformable {
  // MARK: - View Property
  private let titleLabel: UILabel = UILabel().then {
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.body02.font
  }
 
  private let contentLabel: UILabel = UILabel()
  private let arrowImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = Images.vArrowRight.image.withRenderingMode(.alwaysTemplate)
    $0.tintColor = SystemColor.gray500.uiColor
  }
  
  // MARK: - Stored Property
  var title: String? {
    didSet {
      self.titleLabel.text = title
    }
  }
  
  var contentText: String? {
    didSet {
      self.contentLabel.text = contentText
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
  var touchEventRelay: PublishRelay<Void> = .init()

  // MARK: - UIConfigurable
  override func configureUI() {
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
      $0.height.width.equalTo(24)
      $0.trailing.equalToSuperview().inset(12)
    }
  }
  
  // MARK: - UIBindable
  override func bind() {
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
  
  func updateForCurrentState() {
    guard let currentState,
          let config = configurations[currentState] else { return }
    
    contentLabel.text = config.contentText
    contentLabel.font = config.font
    contentLabel.textColor = config.textColor
  }
  
  enum State {
    case validData
    case emptyData
  }
  
  struct Configuration {
    var contentText: String = "지역 입력하면 +10%"
    let font: UIFont
    let textColor: UIColor
    
    public init(contentText: String, font: UIFont, textColor: UIColor) {
      self.contentText = contentText
      self.font = font
      self.textColor = textColor
    }
  }
}


