//
//  ProfileEditMainController.swift
//  FeatureProfileInterface
//
//  Created by 윤지호 on 3/21/24.
//


import UIKit
import SharedDesignSystem

import SnapKit
import RxSwift
import RxCocoa
import ReactorKit

protocol ProfileEditMainControllerDelegate: AnyObject {
  func presentImageGuide()
  func presentSelectImage()
  func presentNickname()
  func presentAddress()
  func presentJob()
  func presentSchool()
  func presentIntroduce()
  func presentMBTI()
  func presentInterests()
}

final class ProfileEditMainController: BaseController {
  // MARK: - View Property
  private let segumentButtonView: ProfileEditSegmentView = ProfileEditSegmentView()
  private let mainView = ProfileEditMainPageViewController()
  private let toastMessageButton: ToastMessageView = ToastMessageView().then {
    $0.layer.masksToBounds = false
    $0.clipsToBounds = false
  }

  // MARK: - Reactor Property
  typealias Reactor = ProfileEditMainReactor
  
  // MARK: - Delegate
  weak var delegate: ProfileEditMainControllerDelegate?
  
  // MARK: - Life Method
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Initialize Method
  required init(reactor: Reactor) {
    defer {
      self.reactor = reactor
    }
    super.init()
  }
  
  deinit {
    print("해제됨: ProfileEditMainController")
  }
  
   // MARK: - UIConfigurable
  override func configureUI() {
    setView()
  }
  
  override func setNavigationBar() {
    customNavigationController?.customNavigationBarConfig = CustomNavigationBarConfiguration(
      titleView: .init(title: "프로필 수정")
    )
  }
}

extension ProfileEditMainController: ReactorKit.View {
  func bind(reactor: ProfileEditMainReactor) {
    segumentButtonView.touchEventRelay
      .bind(with: self) { owner, index in
        owner.reactor?.action.onNext(.changePage(index))
      }
      .disposed(by: disposeBag)
    
    mainView.touchEventRelay
      .bind(with: self) { owner, event in
        switch event {
        case .changePage(let index):
          owner.reactor?.action.onNext(.changePage(index))
          
        case .chatImageGuide:
          owner.showErrorAlert(
            subTitle:
"""
채팅 기능을 사용하지 않으면, 다른 사용자가 내 프로필을 볼 수 없어요.

채팅 중에는 대화 상대가 재화를 사용하여 블러가 해제된 나의 사진을 볼 수 있어요.
""",
            positiveLabel: "확인"
          )
        case .imageGuide:
          owner.delegate?.presentImageGuide()
        case .selectImage:
          owner.delegate?.presentSelectImage()
          
        case .nickname:
          owner.delegate?.presentNickname()
        case .address:
          owner.delegate?.presentAddress()
        case .job:
          owner.delegate?.presentJob()
        case .school:
          owner.delegate?.presentSchool()
        case .introduce:
          owner.delegate?.presentIntroduce()
        case .mbti:
          owner.delegate?.presentMBTI()
        case .interests:
          owner.delegate?.presentInterests()
        }
      }
      .disposed(by: disposeBag)

    reactor.state
      .map(\.pageIndex)
      .bind(with: self) { owner, index in
        owner.segumentButtonView.setIndex(index)
        owner.mainView.setPageIndex(index)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.profileData)
      .bind(with: self) { owner, userData in
        owner.mainView.setUserData(userData: userData)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.editedProfile)
      .distinctUntilChanged()
      .bind(with: self) { owner, type in
        guard type != nil else { return }
        owner.toastMessageButton.showToastMessage(message: reactor.editedProfileToastText)
      }
      .disposed(by: disposeBag)

  }
}

extension ProfileEditMainController {
  private func setView() {
    self.view.addSubview(segumentButtonView)
    self.addChild(mainView)
    self.view.addSubview(mainView.view)
    
    segumentButtonView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(52)
      $0.height.equalTo(44)
      $0.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    mainView.view.snp.makeConstraints {
      $0.top.equalTo(segumentButtonView.snp.bottom)
      $0.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    self.view.addSubview(toastMessageButton)
    toastMessageButton.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
    }
  }
}
