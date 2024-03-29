//
//  MatchCashItemButton.swift
//  FeatureLive
//
//  Created by 윤지호 on 2/29/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SharedDesignSystem

final class MatchCashItemButton: UIControl, Touchable, Highlightable {
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
  
  // MARK: - Rx Property
  let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  public let touchEventRelay = PublishRelay<Void>()
  
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

extension MatchCashItemButton {
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
    backgroundColor = SystemColor.gray100.uiColor
    layer.cornerRadius = 36 / 2 - 1
    addShadow(offset: CGSize())
    
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

extension MatchCashItemButton {
  func setItemCount(candy: Int, ticket: Int) {
    candyCountLabel.text = "\(candy)"
    ticketCountLabel.text = "\(ticket)"
  }
}
