//
//  OnboardingImageGuideController.swift
//  FeatureOnboarding
//
//  Created by 윤지호 on 1/7/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import SharedDesignSystem

public final class OnboardingImageGuideModalView: BaseView {
  // MARK: - View Property
  private let titleLabel: UILabel = UILabel().then {
    $0.text = "사진 인증 가이드"
    $0.font = SystemFont.title02.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  private let certifiedGuideView: CertifiedGuideView = CertifiedGuideView()
  private let segmentControl: UISegmentedControl = UISegmentedControl(items: ["인증 예시", "미인증 예시"]).then {
    $0.setTitleTextAttributes(
      [
        .font: SystemFont.body01.font,
        .foregroundColor: SystemColor.basicBlack.uiColor
      ],
      for: .selected
    )
    $0.setTitleTextAttributes(
      [
        .font: SystemFont.body01.font,
        .foregroundColor: SystemColor.gray500.uiColor
      ],
      for: .normal
    )
    $0.selectedSegmentIndex = 0
  }
  private let seletedRoundButton: FillButton = FillButton().then {
    typealias Configuration = FillButton.Configuration
    let enaleConfig = Configuration(
      backgroundColor: SystemColor.primaryNormal.uiColor,
      isEnabled: true
    )
    
    $0.title = "앨범에서 선택하기"
    $0.setState(enaleConfig, for: .enabled)
    $0.currentState = .enabled
    
    $0.layer.cornerRadius = 8
  }
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touch Property
  public let touchEventRelay: PublishRelay<TouchType> = .init()
  
  // MARK: - Life Method
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  public override func configureUI() {
    setupTitleLabel()
    setupSegmentControl()
    setupCertifiedGuideView()
    setupSeletedButton()
  }
  
  public override func bind() {
    seletedRoundButton.touchEventRelay
      .map { TouchType.tabShowAlbumButtom }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    segmentControl.rx.selectedSegmentIndex
      .map { index in
        let bool = index == 0 ? true : false
        return TouchType.toggleSegment(bool)
      }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension OnboardingImageGuideModalView: Touchable {
  public enum TouchType {
    case toggleSegment(Bool)
    case tabShowAlbumButtom
  }
}

extension OnboardingImageGuideModalView {
  private func setupTitleLabel() {
    addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(28)
      $0.height.equalTo(22)
      $0.centerX.equalToSuperview()
    }
  }
  private func setupSegmentControl() {
    addSubview(segmentControl)
    
    segmentControl.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(20)
      $0.height.equalTo(52)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
  }
  private func setupCertifiedGuideView() {
    addSubview(certifiedGuideView)
    let viewWidth = 375
    let containerWidth = viewWidth - 40
    let containerHeight = (containerWidth * 213) / 335
    certifiedGuideView.snp.makeConstraints {
      $0.top.equalTo(segmentControl.snp.bottom).offset(16)
      $0.height.equalTo(containerHeight)
      $0.leading.trailing.equalToSuperview()
    }
  }
  private func setupSeletedButton() {
    addSubview(seletedRoundButton)
    
    seletedRoundButton.snp.makeConstraints {
      $0.top.equalTo(certifiedGuideView.snp.bottom).offset(44)
      $0.height.equalTo(52)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(28)
    }
  }
}

extension OnboardingImageGuideModalView {
  public func updateView(_ isCertified: Bool) {
    updateCertifiedGuideView(isCertified)
    updateSegmentControl(isCertified)
  }
  private func updateCertifiedGuideView(_ isCertified: Bool) {
    certifiedGuideView.updateViewProperty(isCertified)
  }
  private func updateSegmentControl(_ isCertified: Bool) {
//    let index: Int = !isCertified ? 0 : 1

    
  }
}
