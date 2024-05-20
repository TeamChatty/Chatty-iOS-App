//
//  PreviewPageView.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/28/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

public class PreviewPageView: BaseView, Touchable {
  // MARK: - View Property
  private let scrollView: UIScrollView = UIScrollView()
  private let stackView: UIStackView = UIStackView().then {
    $0.axis = .vertical
  }
  
  private let imageSectionView: PreviewImageSectionView = PreviewImageSectionView()
  private let basicInfoSectionView: PreviewBasicInfoSectionView = PreviewBasicInfoSectionView()
  private let additionalInfoSectionView: PreviewAdditionalInfoSectionView = PreviewAdditionalInfoSectionView()
  private lazy var prolongChatButton: PayActionButton = PayActionButton().then {
    $0.title = "채팅 연장하기"
    $0.cornerRadius = 52 / 2
    $0.paymentIconImage = UIImage(asset: Images.ticketWhite)
    $0.paymentAmountValue = 1
    
    typealias Config = PayActionButton.Configuration
    let config = Config(backgroundColor: SystemColor.primaryNormal.uiColor, isEnabled: true)
    $0.setState(config, for: .enabled)
    $0.currentState = .enabled
  }
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  // MARK: - Touchable Property
  public var touchEventRelay: PublishRelay<TouchEventType> = .init()

  // MARK: - UIConfigurable
  public override func configureUI() {
    setupView()
    setupStackView()
  }
  
  // MARK: - UIBindable
  public override func bind() {
    imageSectionView.touchEventRelay
      .map { _ in TouchEventType.unlockProfileImage }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension PreviewPageView {
  public enum TouchEventType {
    case unlockProfileImage
  }
}

extension PreviewPageView {
  private func setupView() {
    addSubview(scrollView)
    scrollView.addSubview(stackView)
    
    scrollView.snp.makeConstraints {
      $0.horizontalEdges.verticalEdges.equalToSuperview()
    }
    stackView.snp.makeConstraints {
      $0.top.equalTo(scrollView.contentLayoutGuide.snp.top)
      $0.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom)

      $0.width.equalTo(scrollView.frameLayoutGuide.snp.width)
      $0.leading.equalTo(scrollView.frameLayoutGuide.snp.leading)
      $0.trailing.equalTo(scrollView.frameLayoutGuide.snp.trailing)
    }
  }
  
  private func setupStackView() {
    stackView.addArrangedSubview(imageSectionView)
    stackView.addArrangedSubview(basicInfoSectionView)
    stackView.addArrangedSubview(additionalInfoSectionView)
    
    imageSectionView.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.greaterThanOrEqualTo(50)
    }
    
    basicInfoSectionView.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.greaterThanOrEqualTo(50)
    }
    
    additionalInfoSectionView.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.greaterThanOrEqualTo(50)
    }
  }
}

/// Chat UserProfile
extension PreviewPageView {
  /// Chat UserProfile 업데이트
  public func updateUserProfile(profileImage: String?, nickname: String, americanAge: Int, gender: String, blueCheck: Bool, address: String?, job: String?, school: String?, introduce: String?, mbti: String?, interests: [String], isUnlocked: Bool) {
    imageSectionView.updateUserPreview(profileImage: profileImage, nickname: nickname, americanAge: americanAge, gender: gender, blueCheck: blueCheck, isUnlocked: isUnlocked)
    basicInfoSectionView.updateView(address: address, job: job, school: school)
    additionalInfoSectionView.updateView(introduce: introduce, mbti: mbti, interests: interests)
    
    stackView.addArrangedSubview(prolongChatButton)
    prolongChatButton.snp.makeConstraints {
      $0.width.equalToSuperview().inset(20)
      $0.height.equalTo(52)
    }
  }
  
  /// Chat UserProfile - isUnlocked 값 업데이트
  public func updateIsUnlocked(isUnlocked: Bool) {
    imageSectionView.updateIsUnlocked(isUnlocked: isUnlocked)
  }
}

/// MyProfile Preview
extension PreviewPageView {
  /// MyProfile Preview 업데이트
  public func updateUserProfile(profileImage: String?, nickname: String, americanAge: Int, gender: String, blueCheck: Bool, address: String?, job: String?, school: String?, introduce: String?, mbti: String?, interests: [String]) {
    imageSectionView.updateMyPreviewView(profileImage: profileImage, nickname: nickname, americanAge: americanAge, gender: gender, blueCheck: blueCheck)
    basicInfoSectionView.updateView(address: address, job: job, school: school)
    additionalInfoSectionView.updateView(introduce: introduce, mbti: mbti, interests: interests)
  }
}
