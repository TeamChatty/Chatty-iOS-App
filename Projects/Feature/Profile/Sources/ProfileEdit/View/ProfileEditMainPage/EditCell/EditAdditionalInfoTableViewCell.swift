//
//  EditAdditionalInfoTableViewCell.swift
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

final class EditAdditionalInfoTableViewCell: UITableViewCell {
  static let cellId = "EditAdditionalInfoTableViewCell"
  
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
//  private let mbtiButton: ArrowSubtitleButton = ArrowSubtitleButton().then {
//    $0.title = "MBTI"
//  }
  
  private let mbtiButton: UIButton = UIButton().then {
    $0.setTitle("MBTI", for: .normal)
    $0.backgroundColor = .darkGray
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
    setupIntroduce()
    setupMBTI()
    setupInterests()
  }
  // MARK: - UIBindable
  private func bind() {
    introduceButton.touchEventRelay
      .map { TouchEventType.introduce }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    mbtiButton.rx.tap
      .map { TouchEventType.mbti }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
//    mbtiButton.touchEventRelay
//      .map { TouchEventType.mbti }
//      .bind(to: touchEventRelay)
//      .disposed(by: disposeBag)
    
    interestsButton.touchEventRelay
      .map { TouchEventType.interests }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension EditAdditionalInfoTableViewCell {
  func updateCell(userData: UserProfile) {
    self.introduceButton.setIntroduceText(introduce: userData.introduce)
    

  }
}

extension EditAdditionalInfoTableViewCell {
  private func setupIntroduce() {
    contentView.addSubview(introduceHeaderTitle)
    contentView.addSubview(introduceButton)
    
    introduceHeaderTitle.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.height.equalTo(19)
      $0.leading.equalToSuperview().inset(20)
    }
    introduceButton.snp.makeConstraints {
      $0.top.equalTo(introduceHeaderTitle.snp.bottom).offset(20)
      $0.height.greaterThanOrEqualTo(50)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
  }
  
  private func setupMBTI() {
    contentView.addSubview(mbtiHeaderTitle)
    contentView.addSubview(mbtiButton)
    
    mbtiHeaderTitle.snp.makeConstraints {
      $0.top.equalTo(introduceButton.snp.bottom).offset(48)
      $0.height.equalTo(19)
      $0.leading.equalToSuperview().inset(20)
    }
    
    mbtiButton.snp.makeConstraints {
      $0.top.equalTo(mbtiHeaderTitle.snp.bottom).offset(34)
      $0.height.equalTo(48)
      $0.horizontalEdges.equalToSuperview().inset(12)
    }
  }
  
  private func setupInterests() {
    contentView.addSubview(interestsHeaderTitle)
    contentView.addSubview(interestsButton)
    
    interestsHeaderTitle.snp.makeConstraints {
      $0.top.equalTo(mbtiButton.snp.bottom).offset(48)
      $0.height.equalTo(19)
      $0.leading.equalToSuperview().inset(20)
    }
    interestsButton.snp.makeConstraints {
      $0.top.equalTo(interestsHeaderTitle.snp.bottom).offset(34)
      $0.height.equalTo(48)
      $0.horizontalEdges.equalToSuperview().inset(12)
      $0.bottom.equalToSuperview().inset(97)
    }
  }
}

extension EditAdditionalInfoTableViewCell {
  func setdata() {
    
  }
}
