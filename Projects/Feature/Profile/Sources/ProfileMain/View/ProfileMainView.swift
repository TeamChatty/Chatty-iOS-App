//
//  ProfileMainView.swift
//  FeatureProfileInterface
//
//  Created by 윤지호 on 3/17/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

import SharedDesignSystem
import DomainUserInterface

final class ProfileMainView: BaseView, Touchable {
  // MARK: - View Property
  private let scrollView: UIScrollView = UIScrollView().then {
    $0.backgroundColor = .white
  }
  private let stackView: UIStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .top
  }
  
  private let profileBoxView: ProfileMainBoxView = ProfileMainBoxView().then {
    $0.backgroundColor = .white
  }
  
  /// 인앱결제 추가 이후 사용
//  private let profileCashsItemView: ProfileMainCashItemsView = ProfileMainCashItemsView().then {
//    $0.backgroundColor = .white
//  }
  
  private let problemServicesView: ProfileMainProblemServicesView = ProfileMainProblemServicesView().then {
    $0.backgroundColor = .white
  }

  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  
  // MARK: - UIConfigurable
  override func configureUI() {
    setupScrollView()
    setupStackView()
  }
  
  // MARK: - UIBindable
  override func bind() {
    profileBoxView.touchEventRelay
      .map { _ in TouchEventType.editProfile }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
//    profileCashsItemView.touchEventRelay
//      .map { event in
//        switch event {
//        case .possessionItems:
//          return TouchEventType.possessionItems
//        case .membership:
//          return TouchEventType.membership
//        }
//      }
//      .bind(to: touchEventRelay)
//      .disposed(by: disposeBag)
    
    problemServicesView.touchEventRelay
      .map { event in
        switch event {
        case .problemNotice:
          return TouchEventType.problemNotice
        case .problemFrequentlyQuestion:
          return TouchEventType.problemFrequentlyQuestion
        case .problemContactService:
          return TouchEventType.problemContactService
        }
      }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension ProfileMainView {
  enum TouchEventType {
    case editProfile
    
    case possessionItems
    case membership
    
    case problemNotice
    case problemFrequentlyQuestion
    case problemContactService
  }
}

extension ProfileMainView {
  private func setupScrollView() {
    addSubview(scrollView)
    scrollView.addSubview(stackView)
    
    scrollView.snp.makeConstraints {
      $0.horizontalEdges.verticalEdges.equalToSuperview()
    }
    
    stackView.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview()

      $0.top.equalTo(scrollView.contentLayoutGuide.snp.top)
      $0.width.equalTo(scrollView.frameLayoutGuide.snp.width)
      
      $0.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom)
    }
  }
  
  private func setupStackView() {
    stackView.addArrangedSubview(profileBoxView)
    profileBoxView.snp.makeConstraints {
      $0.width.equalToSuperview()
    }
    
//    stackView.addArrangedSubview(profileCashsItemView)
//    profileCashsItemView.snp.makeConstraints {
//      $0.width.equalToSuperview()
//    }
    
    stackView.addArrangedSubview(problemServicesView)
    problemServicesView.snp.makeConstraints {
      $0.width.equalToSuperview()
    }
    

  }
}

extension ProfileMainView {
  func setPercent(percent: Double) {
    self.profileBoxView.setPercent(percent: percent)
  }
  
  func setProfileData(_ data: UserProfile) {
    self.profileBoxView.setProfileData(data)
  }
  
  func setCashItemCount(candyCount: Int, ticketCount: Int) {
//    self.profileCashsItemView.setCashItemsData(candyCount: candyCount, ticketCount: ticketCount)
  }
}
