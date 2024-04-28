//
//  PreviewBasicInfoSectionView.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/28/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

import SharedDesignSystem
import DomainUserInterface

final class PreviewBasicInfoSectionView: BaseView {

  private let basicInfoHeaderTitle: UILabel = UILabel().then {
    $0.text = "기본 정보"
    $0.font = SystemFont.title03.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  
  private let stackView: UIStackView = UIStackView().then {
    $0.axis = .vertical
  }
  
  private let addressLabel: TitleImageLabel = TitleImageLabel(imageSize: 24, imagePosition: .left, space: 10).then {
    $0.font = SystemFont.body02.font
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.image = Images.location.image.withRenderingMode(.alwaysTemplate)
    $0.imageViewTintColor = SystemColor.basicBlack.uiColor
  }
  private let jobLabel: TitleImageLabel = TitleImageLabel(imageSize: 24, imagePosition: .left, space: 10).then {
    $0.font = SystemFont.body02.font
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.image = Images.location.image.withRenderingMode(.alwaysTemplate)
    $0.imageViewTintColor = SystemColor.basicBlack.uiColor
  }
  private let schoolLabel: TitleImageLabel = TitleImageLabel(imageSize: 24, imagePosition: .left, space: 10).then {
    $0.font = SystemFont.body02.font
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.image = Images.school.image.withRenderingMode(.alwaysTemplate)
    $0.imageViewTintColor = SystemColor.basicBlack.uiColor
  }

  // MARK: - UIConfigurable
  override func configureUI() {
    addSubview(basicInfoHeaderTitle)
    addSubview(stackView)
    
    basicInfoHeaderTitle.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.height.equalTo(19)
      $0.leading.equalToSuperview().inset(20)
    }
    
    stackView.snp.makeConstraints {
      $0.top.equalTo(basicInfoHeaderTitle.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(22)
    }
    
    stackView.addArrangedSubview(addressLabel)
    stackView.addArrangedSubview(jobLabel)
    stackView.addArrangedSubview(schoolLabel)
    
    addressLabel.snp.makeConstraints {
      $0.width.equalTo(stackView.snp.width)
      $0.height.equalTo(40)
    }
    
    jobLabel.snp.makeConstraints {
      $0.width.equalTo(stackView.snp.width)
      $0.height.equalTo(40)
    }
    
    schoolLabel.snp.makeConstraints {
      $0.width.equalTo(stackView.snp.width)
      $0.height.equalTo(40)
    }
  }
}

extension PreviewBasicInfoSectionView {
  func updateView(userProfile: UserProfile) {
    if let address = userProfile.address {
      addressLabel.title = address
      addressLabel.textColor = SystemColor.basicBlack.uiColor
    } else {
      addressLabel.title = "미입력"
      addressLabel.textColor = SystemColor.gray600.uiColor
    }
    if let job = userProfile.job {
      jobLabel.title = job
      jobLabel.textColor = SystemColor.basicBlack.uiColor
    } else {
      jobLabel.title = "미입력"
      jobLabel.textColor = SystemColor.gray600.uiColor
    }
    if let school = userProfile.school {
      schoolLabel.title = school
      schoolLabel.textColor = SystemColor.basicBlack.uiColor
    } else {
      schoolLabel.title = "미입력"
      schoolLabel.textColor = SystemColor.gray600.uiColor
    }
  }
}


