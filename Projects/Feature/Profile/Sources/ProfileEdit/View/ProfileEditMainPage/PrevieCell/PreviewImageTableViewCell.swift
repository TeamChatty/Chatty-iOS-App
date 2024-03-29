//
//  PreviewImageTableViewCell.swift
//  FeatureProfileInterface
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

final class PreviewImageTableViewCell: UITableViewCell, Touchable {
  static let cellId = "PreviewImageTableViewCell"
  
  // MARK: - View Property
  private let profileImageView: UIImageView = UIImageView()
  private let nameLabel: UIView = UIView()
  private let ageAndGenderLabel: UILabel = UILabel()
    
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

extension PreviewImageTableViewCell {
  func updateCell(userData: UserProfile) {
    
  }
}
