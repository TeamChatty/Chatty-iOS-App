//
//  MBTIView.swift
//  FeatureOnboardingInterface
//
//  Created by 윤지호 on 12/31/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import SharedDesignSystem

public final class MBTIView: UIView, Touchable {
  // MARK: - View Property
  private let stackView: UIStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .center
    $0.spacing = 8
    $0.distribution = .fillEqually
  }
  
  private let firstSelectToggleButton: MBTIToggleButtonView = MBTIToggleButtonView(.first).then {
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }
  private let secondSelectToggleButton: MBTIToggleButtonView = MBTIToggleButtonView(.second).then {
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }
  private let thirdSelectToggleButton: MBTIToggleButtonView = MBTIToggleButtonView(.third).then {
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }
  private let fourthSelectToggleButton: MBTIToggleButtonView = MBTIToggleButtonView(.fourth).then {
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }
    
  // MARK: - Rx Property
  let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  public var touchEventRelay: RxRelay.PublishRelay<(MBTISeletedState, Bool)> = .init()
  
  // MARK: - Initialize Property
  public override init(frame: CGRect) {
    super.init(frame: frame)
    bind()
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MBTIView {
  private func bind() {
    firstSelectToggleButton.touchEventRelay
      .map { touch in (.first, touch) }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    secondSelectToggleButton.touchEventRelay
      .map { touch in (.second, touch) }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
            
    thirdSelectToggleButton.touchEventRelay
      .map { touch in (.third, touch) }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    fourthSelectToggleButton.touchEventRelay
      .map { touch in (.fourth, touch) }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
  
  private func configureUI() {
    addSubview(stackView)
    stackView.snp.makeConstraints {
      $0.top.height.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(35.5)
    }

    firstSelectToggleButton.snp.makeConstraints {
      $0.height.equalTo(160)
    }
    
    secondSelectToggleButton.snp.makeConstraints {
      $0.height.equalTo(160)
    }
    
    thirdSelectToggleButton.snp.makeConstraints {
      $0.height.equalTo(160)
    }
    
    fourthSelectToggleButton.snp.makeConstraints {
      $0.height.equalTo(160)
    }
    
    stackView.addArrangedSubview(firstSelectToggleButton)
    stackView.addArrangedSubview(secondSelectToggleButton)
    stackView.addArrangedSubview(thirdSelectToggleButton)
    stackView.addArrangedSubview(fourthSelectToggleButton)
  }
}

extension MBTIView {
  public func updateMBTIView(_ mbti: MBTI) {
    firstSelectToggleButton.updateButton(mbti.first)
    secondSelectToggleButton.updateButton(mbti.second)
    thirdSelectToggleButton.updateButton(mbti.third)
    fourthSelectToggleButton.updateButton(mbti.fourth)
  }
}
