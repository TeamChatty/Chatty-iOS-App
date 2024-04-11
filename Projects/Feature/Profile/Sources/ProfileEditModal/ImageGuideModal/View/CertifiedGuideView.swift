//
//  CertifiedGuideView.swift
//  FeatureOnboarding
//
//  Created by 윤지호 on 1/7/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import SharedDesignSystem

public final class CertifiedGuideView: UIView {
  // MARK: - View Property
  private let containerView: UIView = UIView().then {
    $0.backgroundColor = SystemColor.gray100.uiColor
    $0.layer.cornerRadius = 8
  }
  private let titleLabel: UILabel = UILabel().then {
    $0.font = SystemFont.body01.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  private let firstImageView: UIImageView = UIImageView().then {
    $0.backgroundColor = SystemColor.gray300.uiColor
    $0.layer.cornerRadius = 8
  }
  private let secondImageView: UIImageView = UIImageView().then {
    $0.backgroundColor = SystemColor.gray300.uiColor
    $0.layer.cornerRadius = 8
  }
  
  // MARK: - Initialize Method
  public override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension CertifiedGuideView {
  private func configureUI() {
    addSubview(containerView)
    containerView.addSubview(titleLabel)
    containerView.addSubview(firstImageView)
    containerView.addSubview(secondImageView)
    
    /// 사용자 기기의 프레임 width 값
    let viewWidth = CGRect.appFrame.width
    /// padding 값을 뺀 width 값
    let containerWidth = viewWidth - 40
    /// 335: 213 의 비율로 계산된 height 값
    let containerHeight = (containerWidth * 213) / 335
    
    containerView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(20)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(16)
      $0.height.equalTo(17)
      $0.centerX.equalToSuperview()
    }
    
    /// 213:150 비율로 계산된 내부 정사각형의 높이값
    let imageViewHeight = (containerHeight * 150) / 213
    
    firstImageView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(14)
      $0.size.equalTo(imageViewHeight)
      $0.leading.equalToSuperview().inset(12)
    }
    
    secondImageView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(14)
      $0.size.equalTo(imageViewHeight)
      $0.trailing.equalToSuperview().inset(12)
    }
  }
}

extension CertifiedGuideView {
  public func updateViewProperty(_ isCerified: Bool) {
    titleLabel.text = isCerified ? "얼굴이 잘 보이는 사진으로 올려주세요." : "얼굴이 잘 보이지 않으면 미인증 가입돼요."
    let color: UIColor = isCerified ? .blue : .red

//    firstImageView.image = UIImage(named: "cerity-\(isCerified)")
//    secondImageView.image = UIImage(named: "cerity-\(isCerified)")
  }
}
