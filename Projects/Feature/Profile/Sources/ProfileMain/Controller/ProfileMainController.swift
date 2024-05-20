//
//  ProfileMainViewController.swift
//  FeatureProfileInterface
//
//  Created by 윤지호 on 3/17/24.
//

import UIKit
import SharedDesignSystem

import SnapKit
import RxSwift
import RxCocoa
import ReactorKit

protocol ProfileMainControllerDelegate: AnyObject {
  func pushNotificationView()
  func pushSettingView()
  
  func pushProfileEditView()
  func pushCashItemsView()
  func pushMembershipView()
  func pushProblemNotice()
  func pushProblemFrequentlyQuestion()
  func pushProblemContactService()
}

final class ProfileMainController: BaseController {
  // MARK: - View Property
  private let backgroundImageView: UIImageView = UIImageView().then {
    $0.image = Images.matchHomeImage.image
    $0.backgroundColor = .white
    $0.contentMode = .scaleAspectFit
  }
  private let mainView = ProfileMainView()
    
  // MARK: - Reactor Property
  typealias Reactor = ProfileMainReactor
  
  // MARK: - Delegate
  weak var delegate: ProfileMainControllerDelegate?
  
  // MARK: - Life Method
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    reactor?.action.onNext(.viewWillAppear)
    tabBarController?.tabBar.isHidden = false
  }
  
  // MARK: - Initialize Method
  required init(reactor: Reactor) {
    defer {
      self.reactor = reactor
    }
    super.init()
  }
  
  deinit {
    print("해제됨: LiveMainController")
  }
  
   // MARK: - UIConfigurable
  override func configureUI() {
    setView()
  }
  
  override func setNavigationBar() {
    let bellButton = CustomNavigationBarButton(image: Images.bell.image)
    let settingButton = CustomNavigationBarButton(image: Images.setting.image)
    customNavigationController?.customNavigationBarConfig = CustomNavigationBarConfiguration(
      rightButtons: [bellButton, settingButton]
    )
    customNavigationController?.navigationBarEvents(of: BarTouchEvent.self)
      .bind(with: self) { owner, event in
        switch event {
        case .notification:
          owner.delegate?.pushNotificationView()
        case .setting:
          owner.delegate?.pushSettingView()
        }
      }
      .disposed(by: disposeBag)
  }
  
  enum BarTouchEvent: Int, IntCaseIterable {
    case notification
    case setting
  }
}

extension ProfileMainController: ReactorKit.View {
  func bind(reactor: ProfileMainReactor) {
    mainView.touchEventRelay
      .bind(with: self) { owner, event in
        switch event {
        case .editProfile:
          owner.delegate?.pushProfileEditView()
        case .possessionItems:
          owner.delegate?.pushCashItemsView()
        case .membership:
          owner.delegate?.pushMembershipView()
        case .problemNotice:
          owner.delegate?.pushProblemNotice()
        case .problemFrequentlyQuestion:
          owner.delegate?.pushProblemFrequentlyQuestion()
        case .problemContactService:
          owner.delegate?.pushProblemContactService()
        }
      }
      .disposed(by: disposeBag)
    
    
    reactor.state
      .map(\.profileData)
      .bind(with: self) { owner, profileData in
        owner.mainView.setPercent(percent: reactor.inputFinishPercent)
      }
      .disposed(by: disposeBag)

    reactor.state
      .map(\.profileData)
      .bind(with: self) { owner, userData in
        owner.mainView.setProfileData(userData)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.candyCount)
      .bind(with: self) { owner, candyCount in
        owner.mainView.setCashItemCount(candyCount: candyCount, ticketCount: reactor.currentState.ticketCount)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.isLoading)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, isLoading in
        if isLoading {
          owner.showLoadingIndicactor()
        } else {
          owner.hideLoadingIndicator()
        }
      }
      .disposed(by: disposeBag)
  }
}

extension ProfileMainController {
  private func setView() {
    self.view.addSubview(mainView)
    mainView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(52)
      $0.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
}
