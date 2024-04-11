//
//  SettingPhoneAuthenticationSuccessView.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/11/24.
//
//
//import UIKit
//import RxSwift
//import RxCocoa
//import SnapKit
//import SharedDesignSystem
//import Then
//
//final class SettingPhoneAuthenticationSuccessView: BaseView {
//  // MARK: - View Property
//  private let contianerView: UIView = UIView()
//  
//  private let imageView: UIImageView = UIImageView().then {
//    $0.contentMode = .scaleAspectFit
//    $0.tintColor = SystemColor.primaryNormal.uiColor
//  }
//  
//  private let titleLabel: UILabel = UILabel().then {
//    $0.text = "인증 완료"
//    $0.font = SystemFont.headLine01.font
//    $0.textColor = SystemColor.basicBlack.uiColor
//  }
//
//
//  // MARK: - UIConfigurable
//  override func configureUI() {
//    addSubview(contianerView)
//    contianerView.addSubview(imageView)
//    contianerView.addSubview(titleLabel)
//    
//    contianerView.snp.makeConstraints {
//      $0.center.equalToSuperview()
//    }
//    
//    imageView.snp.makeConstraints {
//      $0.size.equalTo(88)
//      $0.top.horizontalEdges.equalToSuperview()
//    }
//    
//    titleLabel.snp.makeConstraints {
//      $0.top.equalTo(imageView.snp.bottom).offset(20)
//      $0.horizontalEdges.bottom.equalToSuperview()
//    }
//  }
//}
