//
//  ProfileEditNicknameModal.swift
//  FeatureProfileInterface
//
//  Created by 윤지호 on 4/4/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import SharedDesignSystem
import ReactorKit

final class ProfileEditNicknameModal: BaseController {
  // MARK: - View Property
  private lazy var mainView = ProfileEditNicknameView()
  
  // MARK: - Reactor Property
  public typealias Reactor = ProfileEditTypeReactor
  
  // MARK: - LifeCycle Method
  public override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Initialize Method
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setupSheet()
  }
  
  required init(reactor: Reactor) {
    defer {
      self.reactor = reactor
    }
    super.init()
  }
  
  weak var delegate: ProfileEditModalDelegate?
  
  public override func configureUI() {
    view.addSubview(mainView)
    
    mainView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
    }
  }
  
  deinit {
    print("해제됨: ProfileEditNicknameModal")
  }
}

extension ProfileEditNicknameModal: ReactorKit.View {
  public func bind(reactor: ProfileEditTypeReactor) {
    mainView.touchEventRelay
      .bind(with: self) { owner, event in
        switch event {
        case .cancel:
          owner.delegate?.dismissModal()
        case .inputText(let text):
          owner.reactor?.action.onNext(.inputNickname(text))
        case .change:
          owner.reactor?.action.onNext(.tabChangeButton)
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.isChangeButtonEnabled)
      .distinctUntilChanged()
      .bind(with: self) { owner, bool in
        owner.mainView.setChangeButtonEnabled(bool)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.isSaveSuccess)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, result in
        if result {
          owner.delegate?.successEdit(editType: .nickname)
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
      .map(\.errorState)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, errorState in
        owner.mainView.setErrorLabel(errorText: errorState?.description)
      }
      .disposed(by: disposeBag)
    
  }
}

extension ProfileEditNicknameModal {
  private func setupSheet() {
    if let sheet = self.sheetPresentationController {
      let contentHeight = mainView.frame.height
      let customDetent = UISheetPresentationController.Detent.custom(identifier: .init("custemDetent")) { _ in
        return contentHeight
      }
      sheet.detents = [customDetent]
      sheet.preferredCornerRadius = 16
    }
  }
}
