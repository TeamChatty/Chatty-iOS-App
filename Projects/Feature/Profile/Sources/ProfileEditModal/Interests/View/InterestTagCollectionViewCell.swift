//
//  InserestTagCollectionViewCell.swift
//  FeatureOnboardingInterface
//
//  Created by 윤지호 on 1/24/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import SharedDesignSystem
import DomainUserInterface

class InterestTagCollectionViewCell: UICollectionViewCell, Touchable {
  static let cellId: String = "InserestTagCollectionViewCell"
  
  // MARK: - View Property
  private let tagView: InterestTagButton = InterestTagButton().then {
    typealias Configuration = InterestTagButton.Configuration
    let selectConfig = Configuration(
      fontColor: SystemColor.primaryNormal.uiColor,
      backgroundColor: SystemColor.primaryLight.uiColor,
      borderColor: SystemColor.primaryStroke.uiColor
    )
    let deselectConfig = Configuration(
      fontColor: SystemColor.basicBlack.uiColor,
      backgroundColor: SystemColor.basicWhite.uiColor,
      borderColor: SystemColor.neutralStroke.uiColor
    )
    $0.setState(selectConfig, for: .selected)
    $0.setState(deselectConfig, for: .deselected)
    
    $0.currentState = .deselected
    
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: self.tagView.tagLabelIntrinsicContentSize, height: 36.0)
  }
  
  var tagText: String {
    return tagView.tagText
  }
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable
  public let touchEventRelay: PublishRelay<Void> = .init()
  
  // MARK: - Initialize Method
  override init(frame: CGRect) {
    super.init(frame: frame)
    bind()
    configureUI()
  } 
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func setData(tag: Interest) {
    tagView.setTag(tag.name)
  }
  
  public func updateCellState() {
    tagView.currentState = .selected
  }
}

extension InterestTagCollectionViewCell {
  private func bind() {
    tagView.touchEventRelay
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
  
  private func configureUI() {
    addSubview(tagView)
    tagView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
}
