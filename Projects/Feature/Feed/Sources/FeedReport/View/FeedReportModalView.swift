//
//  FeedReportModalView.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/4/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import SharedDesignSystem

final class FeedReportModalView: BaseView, Touchable {
  
  // MARK: - View Property
  private let cancelButton: CancelButton = CancelButton()
  private let titleLabel: UILabel = UILabel().then {
    $0.text = "피드 신고"
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.title02.font
  }
  private let descriptionLabel: UILabel = UILabel().then {
    $0.text = "신고하는 이유를 알려주세요. 내용이 사실과 무관할 경우\n강력한 제재를 적용중이며, 신고와 차단이 함께 진행됩니다."
    $0.numberOfLines = 0
    $0.textAlignment = .left
    $0.textColor = SystemColor.gray600.uiColor
    $0.font = SystemFont.body03.font
  }
  
  private let caseButtonsScrollView: UIScrollView = UIScrollView()
  private lazy var caseRadioSegmentView: RadioSegmentControl = RadioSegmentControl<ReportCase>()
  
  private let changeButton: FillButton = FillButton().then {
    $0.title = "신고 완료"
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
    $0.cornerRadius = 8
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
      .bind(to: caseRadioSegmentView.items)
      .disposed(by: disposeBag)
    
    cancelButton.touchEventRelay
      .map { TouchEventType.cancel }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    caseRadioSegmentView.touchEventRelay
      .map { TouchEventType.selectAddress($0) }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  
    changeButton.touchEventRelay
      .map { TouchEventType.change }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension FeedReportModalView {
  enum TouchEventType {
    case cancel
    case selectAddress(ReportCase)
    case change
  }
}

extension FeedReportModalView {
  private func setupHeader() {
    addSubview(titleLabel)
    addSubview(cancelButton)
    addSubview(descriptionLabel)
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(32)
      $0.leading.equalToSuperview().inset(20)
      $0.height.equalTo(22)
    }
    
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(12)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(40)
    }
    
    cancelButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(32)
      $0.size.equalTo(24)
      $0.trailing.equalToSuperview().inset(20)
    }
  }
  
  private func setupAddressButtonsView() {
    addSubview(caseButtonsScrollView)
    let width = CGRect.appFrame.width - 40
    caseButtonsScrollView.addSubview(caseRadioSegmentView)
    
    caseButtonsScrollView.snp.makeConstraints {
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
      $0.height.equalTo(400)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    caseRadioSegmentView.snp.makeConstraints {
      $0.top.equalTo(caseButtonsScrollView.contentLayoutGuide.snp.top)
      $0.width.equalTo(caseButtonsScrollView.frameLayoutGuide.snp.width)
      $0.bottom.equalTo(caseButtonsScrollView.contentLayoutGuide.snp.bottom)
    }
  }
  
  private func setupChangeButton() {
    addSubview(changeButton)
    changeButton.snp.makeConstraints {
      $0.top.equalTo(caseButtonsScrollView.snp.bottom).offset(18)
      $0.height.equalTo(52)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(16)
    }
  }
}

extension FeedReportModalView {
  func setChangeButtonEnabled(_ isEnabled: Bool) {
    changeButton.currentState = isEnabled ? .enabled: .disabled
  }
  
  func setButtonState(selectedCase: ReportCase) {
    
  }
}
