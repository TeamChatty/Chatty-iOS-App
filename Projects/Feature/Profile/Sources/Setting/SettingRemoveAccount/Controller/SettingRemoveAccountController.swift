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

protocol SettingRemoveAccountControllerDelegate: AnyObject {
  func pushToSettingNotificationView()
  func successRemoveAccount()
}

final class SettingRemoveAccountController: BaseController {
  // MARK: - View Property
  private let mainView = SettingRemoveAccountView()
    
  // MARK: - Reactor Property
  typealias Reactor = SettingRemoveAccountReactor
  
  // MARK: - Delegate
  weak var delegate: SettingRemoveAccountControllerDelegate?
  
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
      titleView: .init(title: "계정 삭제")
    )
  }
}

extension SettingRemoveAccountController: ReactorKit.View {
  func bind(reactor: SettingRemoveAccountReactor) {
    
    mainView.touchEventRelay
      .bind(with: self) { owner, event in
        switch event {
        case .showSettingNoti:
          owner.delegate?.pushToSettingNotificationView()
        case .removeAccount:
          owner.reactor?.action.onNext(.TabremoveAccount)
        }
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
    
    reactor.state
      .map(\.isSuccessRemove)
      .distinctUntilChanged()
      .bind(with: self) { owner, bool in
        if bool {
          owner.delegate?.successRemoveAccount()
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.errorState)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, errorState in

      }
      .disposed(by: disposeBag)
  }
}

extension SettingRemoveAccountController {
  private func setView() {
    self.view.addSubview(mainView)
    
    mainView.snp.makeConstraints {
      $0.edges.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
}

