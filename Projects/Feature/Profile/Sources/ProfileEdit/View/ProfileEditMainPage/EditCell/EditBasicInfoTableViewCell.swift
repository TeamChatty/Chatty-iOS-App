//
//  EditBasicInfomationTableViewCell.swift
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

final class EditBasicInfoTableViewCell: UITableViewCell {
  static let cellId = "EditBasicInfoTableViewCell"
  
  // MARK: - View Property
  private let headerTitle: UILabel = UILabel().then {
    $0.text = "기본 정보"
    $0.font = SystemFont.title03.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  
  private let genderButton: UIButton = UIButton()
  private let ageButton: UIButton = UIButton()
  private let nicknameButton: UIButton = UIButton()
  private let addressButton: UIButton = UIButton()
  private let jobButton: UIButton = UIButton()
  private let schoolButton: UIButton = UIButton()

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
    setupButtons()
  }
  
  // MARK: - UIBindable
  private func bind() {
    
  }
}

extension EditBasicInfoTableViewCell {
  func updateCell(userData: UserProfile) {
    
  }
}

extension EditBasicInfoTableViewCell {
  private func setupButtons() {
    addSubview(headerTitle)
    addSubview(genderButton)
    addSubview(ageButton)
    addSubview(nicknameButton)
    addSubview(addressButton)
    addSubview(jobButton)
    addSubview(schoolButton)

    headerTitle.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.height.equalTo(19)
      $0.leading.equalToSuperview().inset(20)
    }
    
    genderButton.snp.makeConstraints {
      $0.top.equalTo(headerTitle.snp.bottom).offset(20)
      $0.height.equalTo(48)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    ageButton.snp.makeConstraints {
      $0.top.equalTo(genderButton.snp.bottom).offset(12)
      $0.height.equalTo(48)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    nicknameButton.snp.makeConstraints {
      $0.top.equalTo(ageButton.snp.bottom).offset(12)
      $0.height.equalTo(48)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    addressButton.snp.makeConstraints {
      $0.top.equalTo(nicknameButton.snp.bottom).offset(12)
      $0.height.equalTo(48)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    jobButton.snp.makeConstraints {
      $0.top.equalTo(addressButton.snp.bottom).offset(12)
      $0.height.equalTo(48)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    schoolButton.snp.makeConstraints {
      $0.top.equalTo(jobButton.snp.bottom).offset(12)
      $0.height.equalTo(48)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(48)
    }
  }
}
