//
//  TwoImageLabelView.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/15/24.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

public final class TwoImageLabelView: UIView {
  // MARK: - View Property
  public let firstImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  public let firstLabel: UILabel = UILabel().then {
    $0.font = SystemFont.title03.font
    $0.textColor = SystemColor.gray700.uiColor
    $0.text = "10"
  }
  
  public let secondImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  public let secondLabel: UILabel = UILabel().then {
    $0.font = SystemFont.title03.font
    $0.textColor = SystemColor.gray700.uiColor
    $0.text = "10"
  }
  
  // MARK: - Initialize Method
  public init(imageSize: Int, imageToLabelSpace: Int, firstToSecondItemSpace: Int) {
    super.init(frame: .zero)
    configureUI(imageSize: imageSize, imageToLabelSpace: imageToLabelSpace, firstToSecondItemSpace: firstToSecondItemSpace)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - UIConfigurable
  private func configureUI(imageSize: Int, imageToLabelSpace: Int, firstToSecondItemSpace: Int) {
    addSubview(firstImageView)
    addSubview(firstLabel)
    addSubview(secondImageView)
    addSubview(secondLabel)
    
    firstImageView.snp.makeConstraints {
      $0.height.width.equalTo(imageSize)
      $0.leading.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
    
    firstLabel.snp.makeConstraints {
      $0.height.equalTo(imageSize)
      $0.width.greaterThanOrEqualTo(1)
      $0.leading.equalTo(firstImageView.snp.trailing).offset(imageToLabelSpace)
      $0.centerY.equalToSuperview()
    }
    
    secondImageView.snp.makeConstraints {
      $0.height.width.equalTo(imageSize)
      $0.leading.equalTo(firstLabel.snp.trailing).offset(firstToSecondItemSpace)
      $0.centerY.equalToSuperview()
    }
    
    secondLabel.snp.makeConstraints {
      $0.height.equalTo(imageSize)
      $0.width.greaterThanOrEqualTo(1)
      $0.leading.equalTo(secondImageView.snp.trailing).offset(imageToLabelSpace)
      $0.trailing.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
  }
}


