//
//  Settng.swift
//  FeatureProfileInterface
//
//  Created by 윤지호 on 4/11/24.
//


import UIKit
import SharedDesignSystem

import SnapKit
import RxSwift
import RxCocoa
import ReactorKit

protocol SettingControllerDelegate: AnyObject {
  func pushNotificationView()
  func pushPhoneNumberChangeView()
  func pushAccountRemoveView()
  func logoutSwitchToOnboading()
}

final class SettingController: BaseController {
  // MARK: - View Property
  private let mainView = SettingView()
    
  // MARK: - Reactor Property
  typealias Reactor = SettingReactor
  
  // MARK: - Delegate
  weak var delegate: SettingControllerDelegate?
  
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
    print("해제됨: SettingController")
  }
  
   // MARK: - UIConfigurable
  override func configureUI() {
    setView()
  }
  
  override func setNavigationBar() {
    customNavigationController?.customNavigationBarConfig = CustomNavigationBarConfiguration(
      titleView: .init(title: "설정")
    )
  }
  
  private func showLogoutAlert() {
    let alertView = CustomAlertView().then {
      $0.title = "로그아웃"
      $0.subTitle = "정말 로그아웃 하시겠어요?."
    }
    alertView.addButton("확인", for: .positive)
    alertView.addButton("취소", for: .negative)
    
    let alertController = CustomAlertController(alertView: alertView, delegate: self)
    navigationController?.present(alertController, animated: false)
  }
  
  public override func destructiveAction() {
    reactor?.action.onNext(.tabLogoutAlertButton)
  }
}

extension SettingController: ReactorKit.View {
  func bind(reactor: SettingReactor) {
    
    mainView.touchEventRelay
      .bind(with: self) { owner, event in
        switch event {
        case .notificationDetail:
          owner.delegate?.pushNotificationView()
        case .phoneNumberChange:
          owner.delegate?.pushPhoneNumberChangeView()
        case .logout:
          owner.showLogoutAlert()
        case .accountRemove:
          owner.delegate?.pushAccountRemoveView()
        }
      }
      .disposed(by: disposeBag)

    reactor.state
      .map(\.isLogout)
      .bind(with: self) { owner, bool in
        if bool {
          owner.delegate?.logoutSwitchToOnboading()
        }
      }
      .disposed(by: disposeBag)
  }
}

extension SettingController {
  private func setView() {
    self.view.addSubview(mainView)
    
    mainView.snp.makeConstraints {
      $0.edges.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
}

