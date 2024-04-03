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
  }
}
