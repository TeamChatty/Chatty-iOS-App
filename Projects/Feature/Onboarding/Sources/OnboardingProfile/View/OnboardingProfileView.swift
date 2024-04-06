//
//  OnboardingProfileView.swift
//  FeatureOnboardingInterface
//
//  Created by 윤지호 on 12/31/23.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SharedDesignSystem
import DomainUserInterface

public final class OnboardingProfileView: BaseView, Touchable {
  
  // MARK: - View Property
  private let containerView: UIView = UIView()
  private let titleTextView = TitleTextView()
  private let contentView: UIView = UIView()
  private let warningLabel: UILabel = UILabel().then {
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.caption02.font
  }
  private let continueButton: FillButton = FillButton().then {
    typealias Configuration = FillButton.Configuration
    let disabledConfig = Configuration(
      backgroundColor: SystemColor.gray300.uiColor,
      isEnabled: false
    )
    let enabledCofig = Configuration(
      backgroundColor: SystemColor.primaryNormal.uiColor,
      isEnabled: true
    )
    
    $0.title = "계속하기"
    $0.setState(enabledCofig, for: .enabled)
    $0.setState(disabledConfig, for: .disabled)
    
    $0.layer.cornerRadius = 8
  }
  
  private weak var maleCheckBoxView: GenderCheckBoxView?
  private weak var femaleCheckBoxView: GenderCheckBoxView?
  private weak var birthDatePicker: UIDatePicker?
  private weak var profileImagePickerView: ChangeableImageButton?
  private weak var profileImageTextBoxView: TextBoxView?
  private weak var interestTagCollectionView: InterestTagCollectionView?
  private weak var mbtiView: MBTIView?
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touch Property
  public let touchEventRelay: PublishRelay<TouchType> = .init()
  
  // MARK: - Life Method
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  // MARK: - UIConfigurable
  override public func configureUI() {
    setContainView()
  }
  
  // MARK: - UIBindable
  override public func bind() {
    continueButton.touchEventRelay
      .map { TouchType.continueButton }
      .bind(to: self.touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension OnboardingProfileView {
  public enum TouchType {
    case tabGender(Gender)
    case setBirth(Date)
    case continueButton
    case tabImagePicker
    case tabTag(Interest)
    case toggleMBTI(MBTISeletedState, Bool)
  }

  private func bindGender() {
    maleCheckBoxView?.touchEventRelay
      .map { TouchType.tabGender(.male) }
      .bind(to: self.touchEventRelay)
      .disposed(by: disposeBag)
    
    femaleCheckBoxView?.touchEventRelay
      .map { TouchType.tabGender(.female) }
      .bind(to: self.touchEventRelay)
      .disposed(by: disposeBag)
  }
  
  private func bindBirth() {
    birthDatePicker?.rx.date
      .map { TouchType.setBirth($0) }
      .bind(to: self.touchEventRelay)
      .disposed(by: disposeBag)
  }
  
  private func bindProfileImage() {
    profileImagePickerView?.touchEventRelay
      .map { TouchType.tabImagePicker }
      .bind(to: self.touchEventRelay)
      .disposed(by: disposeBag)
  }
  
  private func bindInterest() {
    interestTagCollectionView?.touchEventRelay
      .map { TouchType.tabTag($0) }
      .bind(to: self.touchEventRelay)
      .disposed(by: disposeBag)
  }

  private func bindMBTI() {
    mbtiView?.touchEventRelay
      .map { touch in TouchType.toggleMBTI(touch.0, touch.1) }
      .bind(to: self.touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension OnboardingProfileView {
  
  private func setContainView() {
    addSubview(containerView)
    containerView.addSubview(titleTextView)
    containerView.addSubview(contentView)
    containerView.addSubview(warningLabel)
    containerView.addSubview(continueButton)
    
    containerView.snp.makeConstraints{
      $0.top.equalToSuperview().offset(16)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    titleTextView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.height.greaterThanOrEqualTo(75)
    }
    
    contentView.snp.makeConstraints {
      $0.top.equalTo(titleTextView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.lessThanOrEqualTo(600)
    }
    
    warningLabel.snp.makeConstraints {
      $0.height.equalTo(18)
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(continueButton.snp.top).inset(-11)
    }
    
    continueButton.snp.makeConstraints {
      $0.height.equalTo(52)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-16)
    }
  }
  
  private func setupGenderCheckBoxView() {
    let maleCheckBoxView = GenderCheckBoxView().then {
      typealias Configuration = GenderCheckBoxView.Configuration
      let unchecked = Configuration(tintColor: SystemColor.gray500.uiColor)
      let checked = Configuration(tintColor: SystemColor.primaryNormal.uiColor)
      
      $0.setState(unchecked, for: .unChecked)
      $0.setState(checked, for: .checked)
      $0.currentState = .unChecked
      $0.genderType = .male
    }
    let femaleCheckBoxView = GenderCheckBoxView().then {
      typealias Configuration = GenderCheckBoxView.Configuration
      let unchecked = Configuration(tintColor: SystemColor.gray500.uiColor)
      let checked = Configuration(tintColor: SystemColor.primaryNormal.uiColor)
      
      $0.setState(unchecked, for: .unChecked)
      $0.setState(checked, for: .checked)
      $0.currentState = .unChecked
      $0.genderType = .female
    }
    
    contentView.addSubview(maleCheckBoxView)
    contentView.addSubview(femaleCheckBoxView)
    
    femaleCheckBoxView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(56)
      $0.trailing.leading.equalToSuperview().inset(20)
      $0.height.equalTo(46)
    }
    maleCheckBoxView.snp.makeConstraints {
      $0.top.equalTo(femaleCheckBoxView.snp.bottom).offset(12)
      $0.trailing.leading.equalToSuperview().inset(20)
      $0.height.equalTo(46)
    }
    
    self.maleCheckBoxView = maleCheckBoxView
    self.femaleCheckBoxView = femaleCheckBoxView
  }
  
  private func setupDatePicker() { 
    let datePicker = UIDatePicker().then {
      $0.datePickerMode = .date
      $0.preferredDatePickerStyle = .wheels
    }
    contentView.addSubview(datePicker)
    datePicker.snp.makeConstraints {
      $0.top.equalToSuperview().inset(45)
      $0.leading.trailing.equalToSuperview().inset(39)
    }
    self.birthDatePicker = datePicker
  }
  
  private func setupProfileImagePicker() {
    let profleImageTextBoxView = TextBoxView()
    let profileImagePickerView = ChangeableImageButton().then {
      typealias Configuration = ChangeableImageButton.Configuration
      
      let emptyState = Configuration(
        image: UIImage(systemName: "plus")!,
        tintColor: SystemColor.gray600.uiColor,
        size: 26.67,
        isEnabled: true
      )
      let inpuedState = Configuration(
        image: UIImage(),
        tintColor: .clear,
        size: 0,
        isEnabled: true
      )
      
      $0.setState(emptyState, for: .systemImage)
      $0.setState(inpuedState, for: .customImage)
      $0.currentState = .systemImage
      
      $0.layer.cornerRadius = 160 / 2
      $0.clipsToBounds = true
      $0.backgroundColor = SystemColor.gray100.uiColor
      $0.layer.borderWidth = 1
      $0.layer.borderColor = SystemColor.gray300.uiColor.cgColor
    }
        
    contentView.addSubview(profleImageTextBoxView)
    contentView.addSubview(profileImagePickerView)

    profileImagePickerView.snp.makeConstraints {
      $0.size.equalTo(160)
      $0.centerX.centerY.equalToSuperview()
    }
    profleImageTextBoxView.snp.makeConstraints {
      $0.bottom.equalTo(profileImagePickerView.snp.top).offset(-12)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(204)
      $0.height.equalTo(47)
    }
    self.profileImagePickerView = profileImagePickerView
    self.profileImageTextBoxView = profleImageTextBoxView

  }
  
  private func setupInterestTagView() {
    let interestTagCollectionView = InterestTagCollectionView()
    
    contentView.addSubview(interestTagCollectionView)
    interestTagCollectionView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(56)
      $0.height.equalTo(400)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
    self.interestTagCollectionView = interestTagCollectionView
  }
  
  private func setupMBTIView() {
    let mbtiView = MBTIView()
    contentView.addSubview(mbtiView)
    mbtiView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(56)
      $0.height.equalTo(200)
      $0.leading.trailing.equalToSuperview()
    }
    self.mbtiView = mbtiView
  }
}

extension OnboardingProfileView {
  public func updateTitleTextView(_ type: EditProfileType, nickName: String = "") {
    titleTextView.updateTitleLabels(type, nickName: nickName)
    warningLabel.text = type.warningDescription
    
    switch type {
    case .gender:
      setupGenderCheckBoxView()
      bindGender()
    case .birth:
      setupDatePicker()
      bindBirth()
    case .profileImage:
      setupProfileImagePicker()
      bindProfileImage()
    case .interest:
      setupInterestTagView()
      bindInterest()
    case .mbti:
      setupMBTIView()
      bindMBTI()
    case .none:
      print("none")
    }
  }
  
  public func setGender(_ gender: Gender) {
    maleCheckBoxView?.updateForCurrentState(gender)
    femaleCheckBoxView?.updateForCurrentState(gender)
  }
  
  public func updateContinuBtn(_ state: Bool) {
    if state {
      continueButton.currentState = .enabled
    } else {
      continueButton.currentState = .disabled
    }
  }
  
  public func updateProfileImageView(_ image: UIImage?) {
    if image == nil {
      profileImageTextBoxView?.updateProfileImage(false)
      profileImagePickerView?.currentState = .systemImage
    } else {
      profileImageTextBoxView?.updateProfileImage(true)
      profileImagePickerView?.updateStateConfigure(.customImage, image: image ?? UIImage())
      profileImagePickerView?.currentState = .customImage
    }
  }
  
  public func updateInterestCollectionView(_ tags: [Interest]) {
    interestTagCollectionView?.updateCollectionView(tags)
  }
  
  public func updateInterestCollectionCell(_ tags: [Interest]) {
    interestTagCollectionView?.updateCell(tags)
  }
  
  public func updateMBTIView(_ mbti: MBTI) {
    mbtiView?.updateMBTIView(mbti)
  }
}
