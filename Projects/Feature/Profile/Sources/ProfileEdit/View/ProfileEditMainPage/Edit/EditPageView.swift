//
//  EditPageView.swift
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

final class EditPageView: BaseView, Touchable {
  // MARK: - View Property
  private let scrollView: UIScrollView = UIScrollView()
  private let stackView: UIStackView = UIStackView().then {
    $0.axis = .vertical
  }
  
  private let imageSectionView: EditImageSectionView = EditImageSectionView()
  private let basicInfoSectionView: EditBasicInfoSectionView = EditBasicInfoSectionView()
  private let additionalInfoSectionView: EditAdditionalInfoSectionView = EditAdditionalInfoSectionView()
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()

  // MARK: - UIConfigurable
  override func configureUI() {
    setupView()
    setupStackView()
  }
  
  // MARK: - UIBindable
  override func bind() {
    imageSectionView.touchEventRelay
      .map { event in
        switch event {
        case .chatImageGuide:
          return TouchEventType.chatImageGuide
        case .imageGuide:
          return TouchEventType.imageGuide
        case .selectImage:
          return TouchEventType.selectImage
        }
      }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    basicInfoSectionView.touchEventRelay
      .map { event in
        switch event {
        case .nickname:
          return TouchEventType.nickname
        case .address:
          return TouchEventType.address
        case .job:
          return TouchEventType.job
        case .school:
          return TouchEventType.school
        }
      }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    additionalInfoSectionView.touchEventRelay
      .map { event in
        switch event {
        case .introduce:
          return TouchEventType.introduce
        case .mbti:
          return TouchEventType.mbti
        case .interests:
          return TouchEventType.interests
        }
      }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension EditPageView {
  enum TouchEventType {
    case chatImageGuide
    case imageGuide
    case selectImage
    
    case nickname
    case address
    case job
    case school
    
    case introduce
    case mbti
    case interests
  }
}

extension EditPageView {
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

extension EditPageView {
  func updateUserProfile(_ userProfile: UserProfile) {
    imageSectionView.updateView(userProfile: userProfile)
    basicInfoSectionView.updateView(userProfile: userProfile)
    additionalInfoSectionView.updateView(userProfile: userProfile)
  }
}
