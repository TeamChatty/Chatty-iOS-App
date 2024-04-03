//
//  ObboardingNickNameController.swift
//  FeatureOnboardingInterface
//
//  Created by 윤지호 on 1/4/24.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit
import ReactorKit
import SharedDesignSystem

public final class OnboardingNickNameController: BaseController {
  // MARK: - ViewProperty
  private let nickNameView: OnboardingNickNameView = OnboardingNickNameView()
  
  // MARK: - Reactor
  public typealias Reactor = OnboardingNickNameReactor

  // MARK: - Life Cycle
  public override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Initialize Method
  public required init(reactor: Reactor) {
    defer {
      self.reactor = reactor
    }
    super.init()
  }
  
  public weak var delegate: OnboardingNickNameCoordinatorProtocol?
  
  // MARK: - UIConfigurable
  public override func configureUI() {
    view.addSubview(nickNameView)
    nickNameView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(52)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  deinit {
    print("해제됨: NickNameController - NickName")
  }
}

extension OnboardingNickNameController: ReactorKit.View {
  public func bind(reactor: OnboardingNickNameReactor) {
    nickNameView.touchEventRelay
      .bind(with: self) { owner, touch in
        switch touch {
        case .continueButton:
          owner.reactor?.action.onNext(.tabContinueButton)
        }
      }
      .disposed(by: disposeBag)
    
    nickNameView.inputEventRelay
      .bind(with: self) { owner, input in
        switch input {
        case .nickNameText(let nickName):
          owner.reactor?.action.onNext(.inputText(nickName))
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.isButtonEnabled)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, bool in
        owner.nickNameView.updateContinueButtonEnabled(bool)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.checkedResult)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, result in
        owner.nickNameView.updateTextFieldBottomLine(result)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.successSave)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, result in
        if result {
          owner.delegate?.pushToProfiles()
          owner.reactor?.action.onNext(.didPushed)
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
