//
//  PreviewBasicInfoTableViewCell.swift
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

final class PreviewBasicInfoTableViewCell: UITableViewCell {
  static let cellId = "PreviewBasicInfoTableViewCell"

  private let basicInfoHeaderTitle: UILabel = UILabel().then {
    $0.text = "기본 정보"
    $0.font = SystemFont.title03.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  private let address: UILabel = UILabel()
  private let jobLabel: UIView = UIView()
  private let schoolLabel: UIView = UIView()
  
  // MARK: - Initialize Method
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UIConfigurable
  private func configureUI() {
    contentView.addSubview(basicInfoHeaderTitle)
    
    basicInfoHeaderTitle.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.height.equalTo(19)
      $0.leading.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(30)
    }
    
  }
}

extension PreviewBasicInfoTableViewCell {
  func updateCell(userData: UserProfile) {
    
  }
}

