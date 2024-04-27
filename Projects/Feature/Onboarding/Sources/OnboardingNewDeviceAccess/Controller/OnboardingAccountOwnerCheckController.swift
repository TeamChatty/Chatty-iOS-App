//
//  OnboardingAccountOwnerCheckController.swift
//  FeatureOnboardingInterface
//
//  Created by HUNHIE LEE on 1/30/24.
//

import UIKit
import RxSwift
import ReactorKit
import SharedDesignSystem

public final class OnboardingAccountOwnerCheckController: BaseController {
  // MARK: - View Property
  private let mainView = OnboardingAccountOwnerCheckView()
  
  weak var delegate: AccountOwnerCheckDelegate?
  
  // MARK: - Initialize Method
  public required init(reactor: Reactor) {
    defer {
      self.reactor = reactor
    }
    super.init()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  public override func configureUI() {
    view.addSubview(mainView)
    mainView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(52)
      $0.horizontalEdges.bottom.equalToSuperview()
    }
  }
}

extension OnboardingAccountOwnerCheckController: ReactorKit.View {
  public typealias Reactor = AccountSecurityQuestionReactor
  
  public func bind(reactor: Reactor) {
    mainView.touchEventRelay
      .bind(with: self) { owner, touchType in
        switch touchType {
        case .ownedAccount:
          reactor.action.onNext(.getQuestionNickname)
        case .createAccount:
          break
        }
      }
      .disposed(by: disposeBag)
  }
}
