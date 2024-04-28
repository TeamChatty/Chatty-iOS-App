//
//  EditBasicInfoSectionView.swift
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

final class EditBasicInfoSectionView: BaseView, Touchable {
  
  // MARK: - View Property
  private let headerTitle: UILabel = UILabel().then {
    $0.text = "기본 정보"
    $0.font = SystemFont.title03.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  
  private let genderView: TitleContentView = TitleContentView().then {
    $0.title = "성별"
    $0.font = SystemFont.body02.font
    $0.textColor = SystemColor.gray500.uiColor
    $0.backgroundColor = SystemColor.gray100.uiColor
    $0.layer.cornerRadius = 8
  }
  private let ageView: TitleContentView = TitleContentView().then {
    $0.title = "나이"
    $0.font = SystemFont.body02.font
    $0.textColor = SystemColor.gray500.uiColor
    $0.backgroundColor = SystemColor.gray100.uiColor
    $0.layer.cornerRadius = 8
  }
  private let nicknameButton: ArrowSubtitleButton = ArrowSubtitleButton().then {
    typealias Configuration = ArrowSubtitleButton.Configuration
    let emptyData = Configuration(
      font: SystemFont.body01.font,
      textColor: SystemColor.gray500.uiColor
    )
    $0.setState(emptyData, for: .emptyData)
    
    $0.title = "닉네임"
  }
  private let addressButton: ArrowSubtitleButton = ArrowSubtitleButton().then {
    typealias Configuration = ArrowSubtitleButton.Configuration
    let emptyData = Configuration(
      font: SystemFont.body01.font,
      textColor: SystemColor.gray500.uiColor
    )
    $0.setState(emptyData, for: .emptyData)
    
    $0.title = "지역"
  }
  private let jobButton: ArrowSubtitleButton = ArrowSubtitleButton().then {
    typealias Configuration = ArrowSubtitleButton.Configuration
    let emptyData = Configuration(
      font: SystemFont.body01.font,
      textColor: SystemColor.gray500.uiColor
    )
    $0.setState(emptyData, for: .emptyData)
    
    $0.title = "직업"
  }
  private let schoolButton: ArrowSubtitleButton = ArrowSubtitleButton().then {
    typealias Configuration = ArrowSubtitleButton.Configuration
    let emptyData = Configuration(
      font: SystemFont.body01.font,
      textColor: SystemColor.gray500.uiColor
    )
    $0.setState(emptyData, for: .emptyData)
    
    $0.title = "학교"
  }
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  enum TouchEventType {
    case nickname
    case address
    case job
    case school
  }

  // MARK: - UIConfigurable
  override func configureUI() {
    setupButtons()
  }
  
  // MARK: - UIBindable
  override func bind() {
    nicknameButton.touchEventRelay
      .map { TouchEventType.nickname }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    addressButton.touchEventRelay
      .map { TouchEventType.address }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    jobButton.touchEventRelay
      .map { TouchEventType.job }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    schoolButton.touchEventRelay
      .map { TouchEventType.school }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension EditBasicInfoSectionView {
  func updateView(userProfile: UserProfile) {
    genderView.contentText = userProfile.gender?.stringKR
    ageView.contentText = "만 \(userProfile.americanAge)세"
    nicknameButton.contentText = userProfile.nickname
    addressButton.contentText = userProfile.address
    jobButton.contentText = userProfile.job
    schoolButton.contentText = userProfile.school
  }
}

extension EditBasicInfoSectionView {
  private func setupButtons() {
    addSubview(headerTitle)
    addSubview(genderView)
    addSubview(ageView)
    addSubview(nicknameButton)
    addSubview(addressButton)
    addSubview(jobButton)
    addSubview(schoolButton)

    headerTitle.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.height.equalTo(19)
      $0.leading.equalToSuperview().inset(20)
    }
    
    genderView.snp.makeConstraints {
      $0.top.equalTo(headerTitle.snp.bottom).offset(20)
      $0.height.equalTo(48)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    ageView.snp.makeConstraints {
      $0.top.equalTo(genderView.snp.bottom).offset(12)
      $0.height.equalTo(48)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    nicknameButton.snp.makeConstraints {
      $0.top.equalTo(ageView.snp.bottom).offset(12)
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

