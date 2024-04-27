//
//  ChatRoomActivationSheetView.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 15.04.2024.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit
import SharedDesignSystem

public class ChatRoomActivationSheetView: CustomBottomSheetView {
  private let containerView: UIView = UIView()
  private let titleLabel: UILabel = UILabel().then {
    $0.font = SystemFont.title02.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  private let subTitleLabel: UILabel = UILabel().then {
    $0.font = SystemFont.body03.font
    $0.textColor = SystemColor.gray600.uiColor
  }
  private let activeButton: PayActionButton = PayActionButton().then {
    $0.title = "연장하기"
    $0.cornerRadius = 26
    $0.paymentIconImage = UIImage(asset: Images.ticketWhite)
    $0.paymentAmountValue = 1
    
    typealias Config = PayActionButton.Configuration
    let config = Config(backgroundColor: SystemColor.primaryNormal.uiColor, isEnabled: true)
    $0.setState(config, for: .enabled)
    $0.currentState = .enabled
  }
  
  public var touchEventRelay: PublishRelay<Void> = .init()

  public var title: String? {
    didSet {
      titleLabel.text = title
    }
  }
  
  public var subTitle: String? {
    didSet {
      subTitleLabel.text = subTitle
    }
  }
  
  public let height: CGFloat = 136
  
  public override func configureUI() {
    addSubview(containerView)
    containerView.addSubview(titleLabel)
    containerView.addSubview(subTitleLabel)
    containerView.addSubview(closeButton)
    containerView.addSubview(activeButton)
    
    containerView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(32)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().offset(-46)
      $0.height.equalTo(height)
    }
    
    titleLabel.snp.makeConstraints {
      $0.leading.top.equalToSuperview()
    }
    
    closeButton.snp.makeConstraints {
      $0.trailing.top.equalToSuperview()
      $0.size.equalTo(24)
    }
    
    subTitleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.top.equalTo(titleLabel.snp.bottom).offset(12)
      $0.trailing.equalToSuperview()
    }
    
    activeButton.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(52)
      $0.bottom.equalToSuperview()
    }
  }
}
