//
//  ProfileEditMainView.swift
//  FeatureProfileInterface
//
//  Created by 윤지호 on 3/21/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

import SharedDesignSystem
import DomainUserInterface

enum ProfileEditMainType {
  case edit
  case preview
}

enum ProfileEditMainCellType {
  case profileImage
  case basicInformation
  case additionalInformation
}

final class ProfileEditMainPageTypeViewController: UIViewController {
  // MARK: - View Property
  private var editPageView: EditPageView?
  private var previewPageView: PreviewPageView?
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  
  private let pageType: ProfileEditMainType
  private var userData: UserProfile? = nil
  
  // MARK: - Initialize Method
  required init(pageType: ProfileEditMainType) {
    self.pageType = pageType
    switch pageType {
    case .edit:
      editPageView = EditPageView()
    case .preview:
      previewPageView = PreviewPageView()
    }
    super.init(nibName: nil, bundle: nil)
    configureUI(pageType)
    bind(pageType)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UIConfigurable
  private func configureUI(_ type: ProfileEditMainType) {
    switch type {
    case .edit:
      guard let editPageView else { return }
      self.view.addSubview(editPageView)
      editPageView.snp.makeConstraints {
        $0.horizontalEdges.verticalEdges.equalToSuperview()
      }
      
    case .preview:
      guard let previewPageView else { return }
      self.view.addSubview(previewPageView)
      previewPageView.snp.makeConstraints {
        $0.horizontalEdges.verticalEdges.equalToSuperview()
      }
    }
  }
  
  // MARK: - UIBindable
  private func bind(_ type: ProfileEditMainType) {
    switch type {
    case .edit:
      guard let editPageView else { return }
      editPageView.touchEventRelay
        .map { event in
          switch event {
          case .chatImageGuide:
            return TouchEventType.chatImageGuide
          case .imageGuide:
            return TouchEventType.imageGuide
          case .selectImage:
            return TouchEventType.selectImage
          case .nickname:
            return TouchEventType.nickname
          case .address:
            return TouchEventType.address
          case .job:
            return TouchEventType.job
          case .school:
            return TouchEventType.school
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
      
    case .preview:
      return
    }
  }
}

extension ProfileEditMainPageTypeViewController {
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

extension ProfileEditMainPageTypeViewController {
  func updateUserProfile(userProfile: UserProfile) {
    switch pageType {
    case .edit:
        editPageView?.updateUserProfile(userProfile)
    case .preview:
      previewPageView?.updateUserProfile(profileImage: userProfile.imageUrl, nickname: userProfile.nickname ?? "", americanAge: userProfile.americanAge, gender: userProfile.genderStringKR, blueCheck: userProfile.blueCheck, address: userProfile.address, job: userProfile.job, school: userProfile.school, introduce: userProfile.introduce, mbti: userProfile.mbti, interests: userProfile.interests.map { $0.name })
    }
  }
}
