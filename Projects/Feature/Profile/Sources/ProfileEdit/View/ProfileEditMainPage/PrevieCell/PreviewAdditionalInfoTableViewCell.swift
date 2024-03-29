//
//  PreviewAdditionalInfoTableViewCell.swift
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
import DomainUserInterface

final class PreviewAdditionalInfoTableViewCell: UITableViewCell, Touchable {
  static let cellId = "PreviewAdditionalInfoTableViewCell"

  // MARK: - View Property
  private let introduceLabel: UILabel = UILabel()
  private let mbtiLbel: UILabel = UILabel()
  private let interestsStackView: UIStackView = UIStackView()
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  enum TouchEventType {
    
  }
  
  // MARK: - Initialize Method
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UIConfigurable
  private func configureUI() {
    
  }
  
  // MARK: - UIBindable
  private func bind() {
    
  }
}

extension PreviewAdditionalInfoTableViewCell {
  func updateCell(userData: UserProfile) {
    
  }
}
