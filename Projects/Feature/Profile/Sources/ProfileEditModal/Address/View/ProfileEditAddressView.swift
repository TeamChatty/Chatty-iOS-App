//
//  ProfileEditAddressView.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/4/24.
//

import UIKit
import RxSwift
import RxCocoa
import SharedDesignSystem

final class ProfileEditAddressView: BaseView, Touchable {
  
  // MARK: - View Property
  private let cancelButton: CancelButton = CancelButton()
  private let titleLabel: UILabel = UILabel().then {
    $0.text = "지역 변경"
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.title02.font
  }
  private let addressButtonsScrollView: UIScrollView = UIScrollView()
  private lazy var addressRadioSegmentView: RadioSegmentControl = RadioSegmentControl<AddressCase>()
  
  private let changeButton: FillButton = FillButton().then {
    $0.title = "변경하기"
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
  
  // MARK: - Stored Property
  public let items: PublishRelay<[RadioSegmentItem]> = .init()
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()

  // MARK: - UIConfigurable
  override func configureUI() {
    setupHeader()
    setupAddressButtonsView()
    setupChangeButton()
  }
  
  // MARK: - UIBindable
  override func bind() {
    items
      .bind(to: addressRadioSegmentView.items)
      .disposed(by: disposeBag)
    
    cancelButton.touchEventRelay
      .map { TouchEventType.cancel }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    addressRadioSegmentView.touchEventRelay
      .map { TouchEventType.selectAddress($0) }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  
    changeButton.touchEventRelay
      .map { TouchEventType.change }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension ProfileEditAddressView {
  enum TouchEventType {
    case cancel
    case selectAddress(AddressCase)
    case change
  }
}

extension ProfileEditAddressView {
  private func setupHeader() {
    addSubview(titleLabel)
    addSubview(cancelButton)
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(32)
      $0.leading.equalToSuperview().inset(20)
      $0.height.equalTo(22)
    }
    
    cancelButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(32)
      $0.size.equalTo(24)
      $0.trailing.equalToSuperview().inset(20)
    }
  }
  
  private func setupAddressButtonsView() {
    addSubview(addressButtonsScrollView)
    let width = CGRect.appFrame.width - 40
    addressButtonsScrollView.contentSize = CGSize(width: width, height: 1000)
    addressButtonsScrollView.addSubview(addressRadioSegmentView)
    
    addressButtonsScrollView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(12)
      $0.height.equalTo(400)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    addressRadioSegmentView.snp.makeConstraints {
      $0.top.equalTo(addressButtonsScrollView.contentLayoutGuide.snp.top)
      $0.width.equalTo(addressButtonsScrollView.frameLayoutGuide.snp.width)
      $0.bottom.equalTo(addressButtonsScrollView.contentLayoutGuide.snp.bottom)
    }
  }
  
  private func setupChangeButton() {
    addSubview(changeButton)
    changeButton.snp.makeConstraints {
      $0.top.equalTo(addressButtonsScrollView.snp.bottom).offset(12)
      $0.height.equalTo(52)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(16)
    }
  }
}

extension ProfileEditAddressView {
  func setChangeButtonEnabled(_ isEnabled: Bool) {
    changeButton.currentState = isEnabled ? .enabled: .disabled
  }
  
  func setButtonState(selectedAddress: AddressCase) {
    
  }
}
