//
//  OnboardingPhoneNumberEntryController.swift
//  FeatureOnboardingInterface
//
//  Created by walkerhilla on 12/29/23.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SharedDesignSystem

public final class OnboardingPhoneNumberEntryController: BaseController {
  // MARK: - View Property
  private let mainView = OnboardingPhoneNumberEntryView()
  
  // MARK: - Reactor Property
  public typealias Reactor = OnboardingPhoneAuthenticationReactor
  
  // MARK: - Delegate
  weak var delegate: OnboardingPhoneAuthenticationCoordinatorProtocol?
  
  // MARK: - Life Method
  public override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    mainView.activatePhoneNumberField()
  }
  
  // MARK: - Initialize Method
  public required init(reactor: Reactor) {
    defer {
      self.reactor = reactor
    }
    super.init()
  }
  
  deinit {
    print("해제됨: OnboardingPhoneNumberEntryController")
  }
  
  // MARK: - UIConfigurable
  public override func configureUI() {
    baseNavigationController?.setBaseNavigationBarHidden(false, animated: true)
    view.addSubview(mainView)
    mainView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(52)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
  
  public func activateTextField() {
    mainView.activatePhoneNumberField()
  }
  
  private func requestSMS(with phoneNumber: String) {
    let title = phoneNumber.formattedPhoneNumber()
    let message = "이 전화번호로 인증번호 메시지를 보낼게요."
    let alertController = CustomAlertController(title: title, message: message, delegate: self)
    let sendAction = CustomAlertAction(text: "전송", style: .destructive)
    let cancelAction = CustomAlertAction(text: "취소", style: .cancel)
    
    alertController.addAction(sendAction)
    alertController.addAction(cancelAction)
    navigationController?.present(alertController, animated: false)
  }
}

extension OnboardingPhoneNumberEntryController: ReactorKit.View {
  public func bind(reactor: OnboardingPhoneAuthenticationReactor) {
    mainView.inputEventRelay
      .subscribe(with: self) { owner, input in
        switch input {
        case .phoneNumber(let phoneNumber):
          reactor.action.onNext(.phoneNumberEntered(phoneNumber))
        }
      }
      .disposed(by: disposeBag)
    
    mainView.touchEventRelay
      .bind(with: self) { owner, _ in
        owner.view.endEditing(true)
        let phoneNumber = reactor.currentState.phoneNumber
        owner.requestSMS(with: phoneNumber)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.isSendSMSButtonEnabled)
      .subscribe(with: self) { owner, state in
        owner.mainView.setRequestSMSButtonIsEnabled(for: state)
      }
      .disposed(by: disposeBag)
  }
}

extension OnboardingPhoneNumberEntryController: CustomAlertDelegate {
  public func destructiveAction() {
    delegate?.pushToVerificationCodeEntryView(self.reactor)
  }
  
  public func cancelAction() {
    self.activateTextField()
  }
}
