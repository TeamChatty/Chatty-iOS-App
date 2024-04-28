//
//  IntroduceButton.swift
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

final class IntroduceButton: BaseControl, Touchable, Highlightable, Transformable {
  // MARK: - View Property
  private let introduceLabel: VerticalAlignLabel = VerticalAlignLabel().then {
    $0.text = "내 소개를 10자 이상 작성해주세요. 예를 들면 최근 관심사, 쉬는 날에는 뭐 하는지 등 상관없어요. 다만 성적인 내용을 암시하는 내용이나 SNS계정을 공유하면 채티 계정이 정지될 수 있습니다."
    $0.textColor = SystemColor.gray500.uiColor
    $0.font = SystemFont.body01.font
    $0.numberOfLines = 0
    $0.sizeToFit()
  }
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<Void> = .init()

  // MARK: - UIConfigurable
  override func configureUI() {
    addSubview(introduceLabel)
    introduceLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(16)
      $0.height.greaterThanOrEqualTo(40)
      $0.horizontalEdges.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().inset(24)
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

extension IntroduceButton {
  func setIntroduceText(introduce: String? = nil) {
    if let introduce {
      introduceLabel.text = introduce
    } else {
      introduceLabel.text = "내 소개를 10자 이상 작성해주세요. 예를 들면 최근 관심사, 쉬는 날에는 뭐 하는지 등 상관없어요. 다만 성적인 내용을 암시하는 내용이나 SNS계정을 공유하면 채티 계정이 정지될 수 있습니다."
    }
  }
}

