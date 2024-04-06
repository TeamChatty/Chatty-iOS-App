//
//  MBTIButton.swift
//  FeatureOnboarding
//
//  Created by 윤지호 on 1/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Then
import SnapKit
import SharedDesignSystem

final class MBTIButtonView: UIControl, Touchable, Highlightable {
  // MARK: - View Property
  private let mbtiLabel: UILabel = UILabel().then {
    $0.font = SystemFont.headLine02.font
  }
  private let summaryLabel: UILabel = UILabel().then {
    $0.font = SystemFont.caption02.font
  }
  
  // MARK: - Rx Property
  let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  public let touchEventRelay = PublishRelay<Void>()
  
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

extension MBTIButtonView {
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
        self.unhighlight(owner)
      }
      .map { _ in Void() }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
  
  private func configureUI() {
    addSubview(mbtiLabel)
    addSubview(summaryLabel)
    
    mbtiLabel.snp.makeConstraints {
      $0.top.equalTo(16)
      $0.height.equalTo(29)
      $0.centerX.equalToSuperview()
    }
    
    summaryLabel.snp.makeConstraints {
      $0.top.equalTo(mbtiLabel.snp.bottom)
      $0.height.equalTo(18)
      $0.centerX.equalToSuperview()
    }
  }
}

extension MBTIButtonView: StateConfigurable {
  enum State {
    case selected
    case deselected
  }
  
  struct Configuration {
    let tintColor: UIColor
    let fontColor: UIColor
    
    init(tintColor: UIColor, fontColor: UIColor) {
      self.tintColor = tintColor
      self.fontColor = fontColor
    }
  }
  
  public func updateForCurrentState() {
    guard let currentState,
          let config = configurations[currentState] else { return }
    
    self.backgroundColor = config.tintColor
    self.mbtiLabel.textColor = config.fontColor
    self.summaryLabel.textColor = config.fontColor
  }
  
  public func setupLabelText(_ string: (String, String)) {
    mbtiLabel.text = string.0
    summaryLabel.text = string.1
  }
}
