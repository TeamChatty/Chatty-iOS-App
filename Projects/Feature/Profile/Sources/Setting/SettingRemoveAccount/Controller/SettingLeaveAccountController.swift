//
//  SettingLeaveAccountController.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/11/24.
//


import UIKit
import SharedDesignSystem

import SnapKit
import RxSwift
import RxCocoa
import ReactorKit



protocol SettingLeaveAccountControllerDelegate: AnyObject {
  func pushToSettingNotificationView()
  func successRemoveAccount()
}

final class SettingLeaveAccountController: BaseController {
  // MARK: - View Property
  private let mainView = SettingLeaveAccountView()
    
  // MARK: - Stored Property
  private var destructiveActionType: destructiveActionType? = nil

  // MARK: - Reactor Property
  typealias Reactor = SettingLeaveAccountReactor
  
  // MARK: - Delegate
  weak var delegate: SettingLeaveAccountControllerDelegate?
  
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
  
  private func showLeaveAccountAlert() {
    self.destructiveActionType = .leaveAccount
    
    let alertView = CustomAlertView().then {
      $0.title = "회원 탈퇴"
      $0.subTitle = "정말 탈퇴 하시겠습니까?"
    }
    alertView.addButton("확인", for: .positive)
    alertView.addButton("취소", for: .negative)
    
    let alertController = CustomAlertController(alertView: alertView, delegate: self)
    customNavigationController?.present(alertController, animated: false)
  }
  
  private func showSuccessLeaveAccountAlert() {
    self.destructiveActionType = .switchToMain
    
    let alertView = CustomAlertView().then {
      $0.title = "계정 삭제 완료"
      $0.subTitle = "계정이 삭제되었습니다."
    }
    alertView.addButton("확인", for: .positive)
    
    let alertController = CustomAlertController(alertView: alertView, delegate: self)
    customNavigationController?.present(alertController, animated: false)
  }
  
  override func destructiveAction() {
    guard let destructiveActionType = self.destructiveActionType else { return }
    switch destructiveActionType {
    case .leaveAccount:
      reactor?.action.onNext(.TabremoveAccount)
    case .switchToMain:
      self.delegate?.successRemoveAccount()
    }
  }
  
  enum destructiveActionType {
    case leaveAccount
    case switchToMain
  }
}

extension SettingLeaveAccountController: ReactorKit.View {
  func bind(reactor: SettingLeaveAccountReactor) {
    
    mainView.touchEventRelay
      .bind(with: self) { owner, event in
        switch event {
        case .showSettingNoti:
          owner.delegate?.pushToSettingNotificationView()
        case .removeAccount:
          owner.showLeaveAccountAlert()
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
          owner.showSuccessLeaveAccountAlert()
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.errorState)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, errorState in
        switch errorState {
        case .unknownError:
          owner.showErrorAlert(title: "네트워크 오류", subTitle: "다시 시도해주세요", positiveLabel: "확인")
        default:
          return
        }
      }
      .disposed(by: disposeBag)
  }
}

extension SettingLeaveAccountController {
  private func setView() {
    self.view.addSubview(mainView)
    
    mainView.snp.makeConstraints {
      $0.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
      $0.bottom.equalToSuperview()
    }
  }
}

