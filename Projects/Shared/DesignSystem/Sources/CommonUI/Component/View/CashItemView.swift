//
//  CashItemLabel.swift
//  SharedDesignSystem
//
//  Created by 윤지호 on 3/18/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

public final class CashItemView: BaseView {
  // MARK: - View Property
  private let candyImageView: UIImageView = UIImageView().then {
    $0.image = Images.candy.image
    $0.contentMode = .scaleAspectFit
  }
  private let candyCountLabel: UILabel = UILabel().then {
    $0.font = SystemFont.title03.font
    $0.textColor = SystemColor.gray700.uiColor
    $0.text = "10"
  }
  
  private let ticketimageView: UIImageView = UIImageView().then {
    $0.image = Images.tickets.image
    $0.contentMode = .scaleAspectFit
  }
  private let ticketCountLabel: UILabel = UILabel().then {
    $0.font = SystemFont.title03.font
    $0.textColor = SystemColor.gray700.uiColor
    $0.text = "10"
  }
  
  // MARK: - Stored Property
  public var candyCount: Int = 0 {
    didSet {
      self.candyCountLabel.text = "\(candyCount)"
    }
  }
  
  public var ticketCount: Int = 0 {
    didSet {
      self.ticketCountLabel.text = "\(ticketCount)"
    }
  }
  
  
  // MARK: - UIConfigurable
  public override func configureUI() {
    setView()
  }
}

extension CashItemView {
  private func setView() {
    addSubview(candyImageView)
    addSubview(candyCountLabel)
    addSubview(ticketimageView)
    addSubview(ticketCountLabel)
    
    candyImageView.snp.makeConstraints {
      $0.height.width.equalTo(24)
      $0.leading.equalToSuperview().inset(10)
      $0.centerY.equalToSuperview()
    }
    
    candyCountLabel.snp.makeConstraints {
      $0.height.equalTo(24)
      $0.width.greaterThanOrEqualTo(20)
      $0.leading.equalTo(candyImageView.snp.trailing).offset(6)
      $0.centerY.equalToSuperview()
    }
    
    ticketimageView.snp.makeConstraints {
      $0.height.width.equalTo(24)
      $0.leading.equalTo(candyCountLabel.snp.trailing).offset(10)
      $0.centerY.equalToSuperview()
    }
    
    ticketCountLabel.snp.makeConstraints {
      $0.height.equalTo(24)
      $0.width.greaterThanOrEqualTo(20)
      $0.leading.equalTo(ticketimageView.snp.trailing).offset(6)
      $0.trailing.equalToSuperview().inset(12)
      $0.centerY.equalToSuperview()
    }
  }
}

