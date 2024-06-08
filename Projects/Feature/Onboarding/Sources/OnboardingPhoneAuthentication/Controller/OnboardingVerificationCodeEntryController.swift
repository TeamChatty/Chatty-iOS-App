//
//  OnboardingVerificationCodeEntryController.swift
//  FeatureOnboarding
//
//  Created by walkerhilla on 1/8/24.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SharedDesignSystem
import Shared

public final class OnboardingVerificationCodeEntryController: BaseController {
  // MARK: - View Property
  private let mainView = OnboardingVerificationCodeEntryView()
  
  // MARK: - Reactor Property
  public typealias Reactor = OnboardingPhoneAuthenticationReactor
  
  // MARK: - Delegate
  weak var delegate: OnboardingPhoneAuthenticationDelegate?
  
  // MARK: - Initialize Method
  public required init(reactor: Reactor) {
    defer {
      self.reactor = reactor
    }
    super.init()
  }
  
  deinit {
    print("해제됨: OnboardingVerificationCodeEntryController")
  }
  
  // MARK: - Life Method
  public override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    mainView.activateVerificationCodeField()
    reactor?.action.onNext(.viewDidAppear)
  }
  
  public override func configureUI() {
    view.addSubview(mainView)
    mainView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(52)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
}

extension OnboardingVerificationCodeEntryController: ReactorKit.View {
  public func bind(reactor: OnboardingPhoneAuthenticationReactor) {
    mainView.inputEventRelay
      .filter { $0.count == 6 }
      .map { .sendVerificationCode($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.isViewDidAppear)
      .distinctUntilChanged()
      .bind(with: self) { owner, isViewDidAppear in
        if isViewDidAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            owner.mainView.setVerificationCode(code: owner.reactor?.currentState.testVerificationCode ?? "")
          })
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.phoneNumber)
      .distinctUntilChanged()
      .bind(with: self) { owner, phoneNumber in
        owner.mainView.phoneNumber = phoneNumber
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.sendVerificationCodeState)
      .subscribe(with: self) { owner, state in
        switch state {
        case .idle: break
        case .loading: break
        case .success(let type):
          switch type {
          case .signIn:
            print("로그인!")
            AppFlowControl.shared.delegete?.showMainFlow()
          case .signUp:
            print("닉네임으로!")
            owner.delegate?.pushToNickNameView()
          default: break
          }
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.sendCount)
      .bind(with: self) { owner, count in
        owner.mainView.errorNoticeType = .authentificationError(count)
      }
      .disposed(by: disposeBag)
  
    reactor.state
      .map(\.errorState)
      .compactMap { $0 }
      .distinctUntilChanged()
      .subscribe(with: self) { owner, error in
        switch error {
        case .invalidPhoneNumber:
          print("잘못된 번호 형식입니다.")
        case .invalidVerificationCode:
          owner.mainView.title = "인증번호가 맞지 않아요\n다시 눌러주세요"
        case .smsFailed:
          owner.showErrorAlert(title: "인증번호 발송 실패", subTitle: "잠시 후 다시 시도해주세요.", negativeLabel: "확인")
        case .mismatchedDeviceId:
          print("기기 번호가 다릅니다. 계정 확인 화면으로~")
          owner.delegate?.pushToAccountAccess()
        case .unknownError:
          print("알 수 없는 에러입니다.")
        case .alreadyExistUser:
          print("이미 가입한 유저입니다.")
          switch reactor.type {
          case .signIn:
            AppFlowControl.shared.delegete?.showMainFlow()
          case .signUp:
            owner.showErrorAlert(title: "계정 확인", subTitle: "이미 가입된 계정이 있어요.", positiveLabel: "로그인", negativeLabel: "취소", positiveAction:  {
              reactor.action.onNext(.sendVerificationCodeWithout)
            })
          }
        case .profileNotCompleted:
          print("프로필 미완성! 닉네임으로~")
          owner.delegate?.pushToNickNameView()
        }
      }
      .disposed(by: disposeBag)
  }
}
