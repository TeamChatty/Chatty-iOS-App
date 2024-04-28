//
//  EditAdditionalInfoSectionView.swift
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

final class EditAdditionalInfoSectionView: BaseView, Touchable {
  
  // MARK: - View Property
  private let introduceHeaderTitle: UILabel = UILabel().then {
    $0.text = "자기소개"
    $0.font = SystemFont.title03.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  private let introduceButton: IntroduceButton = IntroduceButton().then {
    $0.backgroundColor = SystemColor.gray100.uiColor
    $0.layer.cornerRadius = 8
  }
  
  private let mbtiHeaderTitle: UILabel = UILabel().then {
    $0.text = "MBTI"
    $0.font = SystemFont.title03.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  private let mbtiButton: ArrowSubtitleButton = ArrowSubtitleButton().then {
    typealias Configuration = ArrowSubtitleButton.Configuration
    let emptyData = Configuration(
      font: SystemFont.body01.font,
      textColor: SystemColor.gray500.uiColor
    )
    $0.setState(emptyData, for: .emptyData)
    
    $0.title = "MBTI"
  }
  
  private let interestsHeaderTitle: UILabel = UILabel().then {
    $0.text = "관심사"
    $0.font = SystemFont.title03.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  private let interestsButton: ArrowSubtitleButton = ArrowSubtitleButton().then {
    $0.title = "관심사"
  }
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  enum TouchEventType {
    case introduce
    case mbti
    case interests
  }
  
  // MARK: - UIConfigurable
  override func configureUI() {
    setupIntroduce()
    setupMBTI()
    setupInterests()
  }
  // MARK: - UIBindable
  override func bind() {
    introduceButton.touchEventRelay
      .map { TouchEventType.introduce }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    mbtiButton.touchEventRelay
      .map { TouchEventType.mbti }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    interestsButton.touchEventRelay
      .map { TouchEventType.interests }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension EditAdditionalInfoSectionView {
  public func updateView(userProfile: UserProfile) {
    self.introduceButton.setIntroduceText(introduce: userProfile.introduce)
    self.mbtiButton.title = userProfile.mbti
    let joinedInterests: String = userProfile.interests.map { $0.name }.joined(separator: ",")
    self.interestsButton.title = joinedInterests
  }
}

extension EditAdditionalInfoSectionView {
  private func setupIntroduce() {
    addSubview(introduceHeaderTitle)
    addSubview(introduceButton)
    
    introduceHeaderTitle.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.height.equalTo(19)
      $0.leading.equalToSuperview().inset(20)
    }
    introduceButton.snp.makeConstraints {
      $0.top.equalTo(introduceHeaderTitle.snp.bottom).offset(20)
      $0.height.greaterThanOrEqualTo(120)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
  }
  
  private func setupMBTI() {
    addSubview(mbtiHeaderTitle)
    addSubview(mbtiButton)
    
    mbtiHeaderTitle.snp.makeConstraints {
      $0.top.equalTo(introduceButton.snp.bottom).offset(48)
      $0.height.equalTo(19)
      $0.leading.equalToSuperview().inset(20)
    }
    
    mbtiButton.snp.makeConstraints {
      $0.top.equalTo(mbtiHeaderTitle.snp.bottom).offset(34)
      $0.height.equalTo(48)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
  }
  
  private func setupInterests() {
    addSubview(interestsHeaderTitle)
    addSubview(interestsButton)
    
    interestsHeaderTitle.snp.makeConstraints {
      $0.top.equalTo(mbtiButton.snp.bottom).offset(48)
      $0.height.equalTo(19)
      $0.leading.equalToSuperview().inset(20)
    }
    interestsButton.snp.makeConstraints {
      $0.top.equalTo(interestsHeaderTitle.snp.bottom).offset(34)
      $0.height.equalTo(48)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(97)
    }
  }
}

extension EditAdditionalInfoSectionView {
  func setdata() {
    
  }
}
