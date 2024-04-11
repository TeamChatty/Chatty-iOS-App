//
//  MBTIToggleButtonView.swift
//  FeatureOnboarding
//
//  Created by 윤지호 on 1/8/24.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit
import SharedDesignSystem 

public final class MBTIToggleButtonView: UIView, Touchable {
  // MARK: - View Property
  private let firstButton: MBTIButtonView = MBTIButtonView().then {
    typealias Configuration = MBTIButtonView.Configuration
    let selected = Configuration(
      tintColor: SystemColor.primaryLight.uiColor,
      fontColor: SystemColor.primaryNormal.uiColor
    )
    let deselected = Configuration(
      tintColor: SystemColor.gray100.uiColor,
      fontColor: SystemColor.gray400.uiColor
    )
    $0.setState(selected, for: .selected)
    $0.setState(deselected, for: .deselected)
    $0.currentState = .deselected
  }
  private let secondButton: MBTIButtonView = MBTIButtonView().then {
    typealias Configuration = MBTIButtonView.Configuration
    let selected = Configuration(
      tintColor: SystemColor.primaryLight.uiColor,
      fontColor: SystemColor.primaryNormal.uiColor
    )
    let deselected = Configuration(
      tintColor: SystemColor.gray100.uiColor,
      fontColor: SystemColor.gray400.uiColor
    )
    $0.setState(selected, for: .selected)
    $0.setState(deselected, for: .deselected)
    $0.currentState = .deselected
  }

  // MARK: - Rx Property
  let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  public var touchEventRelay: RxRelay.PublishRelay<Bool> = .init()
  
  
  // MARK: - Initialize Property
  required init(_ mbtiState: MBTISeletedState) {
    super.init(frame: .init())
    bind()
    configureUI()
    setupMBTI(mbtiState)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MBTIToggleButtonView {
  private func bind() {
    firstButton.touchEventRelay
      .map { _ in true }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    secondButton.touchEventRelay
      .map { _ in false }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }

  private func configureUI() {
    setupButtons()
    drawDotLine()
  }
  
  private func setupButtons() {
    addSubview(firstButton)
    addSubview(secondButton)
    
    firstButton.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(80)
    }
    
    secondButton.snp.makeConstraints {
      $0.top.equalTo(firstButton.snp.bottom)
      $0.height.equalTo(80)
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  private func drawDotLine() {
    let dotLine = UIView(frame: .zero).then {
      $0.layer.masksToBounds = false
    }
    
    let path = UIBezierPath()
    let point1 = CGPoint(x: 0, y: 0)
    let point2 = CGPoint(x: 80, y: 0)
    
    let layer = CAShapeLayer()
    layer.strokeColor = SystemColor.gray300.uiColor.cgColor
    layer.lineDashPattern = [4, 4]
    
    path.move(to: point1)
    path.addLine(to: point2)
    
    layer.path = path.cgPath
    dotLine.layer.addSublayer(layer)
    
    addSubview(dotLine)
    dotLine.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(1)
      $0.top.equalToSuperview().inset(80)
    }
  }
}

extension MBTIToggleButtonView {
  public func updateButton(_ state: Bool?) {
    if state == nil {
      firstButton.currentState = .deselected
      secondButton.currentState = .deselected
    } else if state == true {
      firstButton.currentState = .selected
      secondButton.currentState = .deselected
    } else {
      firstButton.currentState = .deselected
      secondButton.currentState = .selected
    }
  }
  
  private func setupMBTI(_ mbtiState: MBTISeletedState) {
    firstButton.setupLabelText(mbtiState.getString(state: true))
    secondButton.setupLabelText(mbtiState.getString(state: false))
  }
}
