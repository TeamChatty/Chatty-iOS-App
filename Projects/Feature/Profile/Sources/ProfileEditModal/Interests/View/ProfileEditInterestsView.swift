//
//  ProfileEditMBTIView.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import SharedDesignSystem
import DomainUserInterface

final class ProfileEditInterestsView: BaseView, Touchable {
  // MARK: - View Property
  private let cancelButton: CancelButton = CancelButton()
  private let titleLabel: UILabel = UILabel().then {
    $0.text = "관심사 설정"
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.title02.font
  }
  private let descriptionLabel: UILabel = UILabel().then {
    $0.text = "관심사나 취미 3가지를 선택해 주세요."
    $0.textColor = SystemColor.gray600.uiColor
    $0.font = SystemFont.body01.font
  }
 
  private let interestTagCollectionView: InterestTagCollectionView = InterestTagCollectionView()

  
  private let changeButton: FillButton = FillButton().then {
    $0.title = "확인"
    typealias Configuration = FillButton.Configuration
    let enabledConfig = Configuration(
      backgroundColor: SystemColor.primaryNormal.uiColor,
      isEnabled: true
    )
    let disabledConfig = Configuration(
      backgroundColor: SystemColor.gray300.uiColor,
      isEnabled: false
    )
    $0.setState(enabledConfig, for: .enabled)
    $0.setState(disabledConfig, for: .disabled)

    $0.currentState = .enabled
    $0.cornerRadius = 52 / 2
  }
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()

  // MARK: - UIConfigurable
  override func configureUI() {
    setupHeader()
    setupInterestTagCollectionView()
    setupChangeButton()
  }
  
  // MARK: - UIBindable
  override func bind() {
    cancelButton.touchEventRelay
      .map { TouchEventType.cancel }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    interestTagCollectionView.touchEventRelay
      .map { TouchEventType.tabTag($0) }
      .bind(to: self.touchEventRelay)
      .disposed(by: disposeBag)
    
    changeButton.touchEventRelay
      .map { TouchEventType.change }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension ProfileEditInterestsView {
  enum TouchEventType {
    case cancel
    case tabTag(Interest)
    case change
  }
}

extension ProfileEditInterestsView {
  private func setupHeader() {
    addSubview(titleLabel)
    addSubview(descriptionLabel)
    addSubview(cancelButton)
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(32)
      $0.leading.equalToSuperview().inset(20)
      $0.height.equalTo(22)
    }
    
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(12)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(20)
    }
    
    cancelButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(32)
      $0.size.equalTo(24)
      $0.trailing.equalToSuperview().inset(20)
    }
  }
  
  private func setupInterestTagCollectionView() {
    addSubview(interestTagCollectionView)
    interestTagCollectionView.snp.makeConstraints {
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
      $0.height.equalTo(240)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
  }
  
 
  private func setupChangeButton() {
    addSubview(changeButton)
    changeButton.snp.makeConstraints {
      $0.top.equalTo(interestTagCollectionView.snp.bottom).offset(32)
      $0.height.equalTo(52)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(16)
    }
  }
}

extension ProfileEditInterestsView {
  public func updateInterestCollectionView(_ tags: [Interest]) {
    interestTagCollectionView.updateCollectionView(tags)
  }
  
  public func updateInterestCollectionCell(_ tags: [Interest]) {
    interestTagCollectionView.updateCell(tags)
  }
  
  func setChangeButtonEnabled(_ isEnabled: Bool) {
    changeButton.currentState = isEnabled ? .enabled: .disabled
  }
  
  func setErrorLabel(errorText: String?) {
    
  }
}

