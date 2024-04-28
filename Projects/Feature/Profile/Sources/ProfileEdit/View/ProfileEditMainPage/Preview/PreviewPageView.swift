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

import SharedDesignSystem
import DomainUserInterface

final class PreviewPageView: BaseView, Touchable {
  // MARK: - View Property
  private let scrollView: UIScrollView = UIScrollView()
  private let stackView: UIStackView = UIStackView().then {
    $0.axis = .vertical
  }
  
  private let imageSectionView: PreviewImageSectionView = PreviewImageSectionView()
  private let basicInfoSectionView: PreviewBasicInfoSectionView = PreviewBasicInfoSectionView()
  private let additionalInfoSectionView: PreviewAdditionalInfoSectionView = PreviewAdditionalInfoSectionView()
  
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
    
  }
}

extension PreviewPageView {
  enum TouchEventType {
  
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

extension PreviewPageView {
  func updateUserProfile(_ userProfile: UserProfile) {
    imageSectionView.updateView(userProfile: userProfile)
    basicInfoSectionView.updateView(userProfile: userProfile)
    additionalInfoSectionView.updateView(userProfile: userProfile)
  }
}
