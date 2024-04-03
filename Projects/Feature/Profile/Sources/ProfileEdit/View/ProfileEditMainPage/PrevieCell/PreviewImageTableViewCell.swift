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

final class PreviewImageTableViewCell: UITableViewCell {
  static let cellId = "PreviewImageTableViewCell"
  
  // MARK: - View Property
  private let profileImageView: UIImageView = UIImageView()
  private let nameLabel: UIView = UIView()
  private let ageAndGenderLabel: UILabel = UILabel()
  
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
    addSubview(profileImageView)
    
    let height = CGRect.appFrame.size.width
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(height)
      $0.bottom.equalToSuperview().inset(30)
    }
  }
}

extension PreviewImageTableViewCell {
  func updateCell(userData: UserProfile) {
    profileImageView.setImageKF(urlString: userData.imageUrl)
  }
}
