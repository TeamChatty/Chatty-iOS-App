//
//  InterestTagButton.swift
//  FeatureOnboardingInterface
//
//  Created by 윤지호 on 1/24/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import SharedDesignSystem

final class InterestTagButton: UIControl, Touchable, Highlightable {
  
  // MARK: - View Property
  private let tagLabel: BasePaddingLabel = BasePaddingLabel(padding: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)).then {
    $0.font = SystemFont.body02.font
  }
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable
  public let touchEventRelay: PublishRelay<Void> = .init()
  
  // MARK: - StateConfigurable Property
  var configurations: [State : Configuration] = [:]

  var currentState: State? {
    didSet {
      updateForCurrentState()
    }
  }
  
  // MARK: - Initialize Method
  required init() {
    super.init(frame: .init())
    bind()
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension InterestTagButton: StateConfigurable {
  enum State {
    case selected
    case deselected
  }
  
  struct Configuration {
    let fontColor: UIColor
    let backgroundColor: UIColor
    let borderColor: UIColor
    
    init(fontColor: UIColor, backgroundColor: UIColor, borderColor: UIColor) {
      self.fontColor = fontColor
      self.backgroundColor = backgroundColor
      self.borderColor = borderColor
    }
  }
  
  public func updateForCurrentState() {
    guard let currentState,
          let config = configurations[currentState] else { return }
    backgroundColor = config.backgroundColor
    layer.borderColor = config.borderColor.cgColor
    tagLabel.textColor = config.fontColor
  }
  
  private func deselectCurrentState() {
    if currentState == .selected {
      currentState = .deselected
    }
  }
}

extension InterestTagButton {
  private func bind() {
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
        owner.deselectCurrentState()
        self.unhighlight(owner)
      }
      .map { _ in Void() }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
  
  private func configureUI() {
    setView()
    setTagLabel()
  }
  
  private func setView() {
    layer.cornerRadius = 17
    layer.borderWidth = 1
  }
  
  private func setTagLabel() {
    addSubview(tagLabel)
    tagLabel.snp.makeConstraints {
      $0.top.bottom.leading.trailing.equalToSuperview()
    }
  }
}

extension InterestTagButton {
  public var tagLabelIntrinsicContentSize: CGFloat {
    return tagLabel.intrinsicContentSize.width
  }
  
  public var tagText: String {
    return tagLabel.text ?? ""
  }
  
  public func setTag(_ tag: String) {
    tagLabel.text = tag
  }
}
