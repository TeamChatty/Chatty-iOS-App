//
//  Settng.swift
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

protocol SettingNotificationControllerDelegate: AnyObject {
 
}

final class SettingNotificationController: BaseController {
  // MARK: - View Property
  private let mainView = SettingNotificationView()
    
  // MARK: - Reactor Property
  typealias Reactor = SettingNotificationReactor
  
  // MARK: - Delegate
  weak var delegate: SettingNotificationControllerDelegate?
  
  // MARK: - Life Method
  override func viewDidLoad() {
    super.viewDidLoad()
    reactor?.action.onNext(.viewDidLoad)
  }
  
  // MARK: - Initialize Method
  required init(reactor: Reactor) {
    defer {
      self.reactor = reactor
    }
    super.init()
  }
  
  deinit {
    print("해제됨: SettingNotificationController")
  }
  
   // MARK: - UIConfigurable
  override func configureUI() {
    setView()
  }
  
  override func setNavigationBar() {
    customNavigationController?.customNavigationBarConfig = CustomNavigationBarConfiguration(
      titleView: .init(title: "전화번호 변경")
    )
  }
}

extension SettingNotificationController: ReactorKit.View {
  func bind(reactor: SettingNotificationReactor) {
    mainView.touchEventRelay
      .bind(with: self) { owner, event in
        switch event {
        case .marketingNoti(let bool):
          owner.reactor?.action.onNext(.toggleMarketingNoti(bool))
        case .chattingNoti(let bool):
          owner.reactor?.action.onNext(.toggleChattingNoti(bool))
        case .feedNoti(let bool):
          owner.reactor?.action.onNext(.toggleFeedNoti(bool))
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

  }
}

extension SettingNotificationController {
  private func setView() {
    self.view.addSubview(mainView)
    
    mainView.snp.makeConstraints {
      $0.edges.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
}

