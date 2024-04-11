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

final class PreviewAdditionalInfoTableViewCell: UITableViewCell {
  static let cellId = "PreviewAdditionalInfoTableViewCell"

  // MARK: - View Property
  private let introduceHeaderTitle: UILabel = UILabel().then {
    $0.text = "자기소개"
    $0.font = SystemFont.title03.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  private let introduceLabel: IntroduceButton = IntroduceButton().then {
    $0.backgroundColor = SystemColor.gray100.uiColor
    $0.layer.cornerRadius = 8
    $0.isEnabled = false
  }
  
  private let mbtiHeaderTitle: UILabel = UILabel().then {
    $0.text = "MBTI"
    $0.font = SystemFont.title03.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  private let mbtiLabel: TitleContentView = TitleContentView().then {
    $0.font = SystemFont.body01.font
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.backgroundColor = SystemColor.gray100.uiColor
    $0.layer.cornerRadius = 8
  }
  
  private let interestsHeaderTitle: UILabel = UILabel().then {
    $0.text = "관심사"
    $0.font = SystemFont.title03.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  private let interestsStackView: UIStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .leading
    $0.spacing = 8
  }
  
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
    addSubview(introduceHeaderTitle)
    addSubview(introduceLabel)
    
    addSubview(mbtiHeaderTitle)
    addSubview(mbtiLabel)
    
    addSubview(interestsHeaderTitle)
    addSubview(interestsStackView)
    
    introduceHeaderTitle.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.height.equalTo(19)
      $0.leading.equalToSuperview().inset(20)
    }
    
    introduceLabel.snp.makeConstraints {
      $0.top.equalTo(introduceHeaderTitle.snp.bottom).offset(16)
      $0.height.greaterThanOrEqualTo(48)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    mbtiHeaderTitle.snp.makeConstraints {
      $0.top.equalTo(introduceLabel.snp.bottom).offset(30)
      $0.height.equalTo(19)
      $0.leading.equalToSuperview().inset(20)
    }
    
    mbtiLabel.snp.makeConstraints {
      $0.top.equalTo(mbtiHeaderTitle.snp.bottom).offset(16)
      $0.height.equalTo(48)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    interestsHeaderTitle.snp.makeConstraints {
      $0.top.equalTo(mbtiLabel.snp.bottom).offset(30)
      $0.height.equalTo(19)
      $0.leading.equalToSuperview().inset(20)
    }
    
    interestsStackView.snp.makeConstraints {
      $0.top.equalTo(interestsHeaderTitle.snp.bottom).offset(16)
      $0.height.equalTo(36)
      $0.width.greaterThanOrEqualTo(50)
      $0.leading.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(91)
    }
  }
}

extension PreviewAdditionalInfoTableViewCell {
  func updateCell(userData: UserProfile) {
    let introduce = userData.introduce == nil ? "자기소개를 입력해주세요." : userData.introduce
    introduceLabel.setIntroduceText(introduce: introduce)
    mbtiLabel.title = userData.mbti == nil ? "MBTI를 입력해주세요." : userData.mbti
    
    interestsStackView.removeAllArrangedSubViews()
    if userData.interests.isEmpty == false {
      for interest in userData.interests {
        let label = BasePaddingLabel(padding: .init(top: 8, left: 12, bottom: 8, right: 12))
        label.text = interest.name
        label.textColor = SystemColor.basicBlack.uiColor
        label.font = SystemFont.body02.font
        label.backgroundColor = SystemColor.gray100.uiColor
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        
        interestsStackView.addArrangedSubview(label)
      }
    }
  }
}
