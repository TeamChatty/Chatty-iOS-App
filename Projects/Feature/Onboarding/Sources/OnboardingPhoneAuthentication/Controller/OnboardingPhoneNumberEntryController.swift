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
  weak var delegate: OnboardingPhoneAuthenticationDelegate?
  
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
    let alertView = CustomAlertView().then {
      $0.title = title
      $0.subTitle = message
    }
    alertView.addButton("전송", for: .positive)
    alertView.addButton("취소", for: .negative)
    
    let alertController = CustomAlertController(alertView: alertView) { [weak self] in
      self?.reactor?.action.onNext(.sendSMS)
    } negativeAction: { [weak self] in
      self?.activateTextField()
    }

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
    
    reactor.state
      .map(\.sendSMSState)
      .distinctUntilChanged()
      .subscribe(with: self) { [weak self] owner, state in
        guard let self else { return }
        self.hideLoadingIndicator()
        switch state {
        case .idle:
          return
        case .loading:
          self.showLoadingIndicactor()
        case .success:
          self.delegate?.pushToVerificationCodeEntryView(self.reactor)
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.errorState)
      .distinctUntilChanged()
      .bind(with: self) { owner, errorState in
        switch errorState {
        case .phoneAuthentificationDailyRequestLimitExceeded:
          owner.showErrorAlert(title: "일일 인증횟수 초과", positiveLabel: "확인", positiveAction:  { })
        default: break
        }
      }
      .disposed(by: disposeBag)
  }
}
