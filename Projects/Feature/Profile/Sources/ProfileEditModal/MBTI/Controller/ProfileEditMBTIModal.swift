//
//  ProfileEditMBTIModal.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import SharedDesignSystem
import ReactorKit

final class ProfileEditMBTIModal: BaseController {
  // MARK: - View Property
  private lazy var mainView = ProfileEditMBTIView()
  
  // MARK: - Reactor Property
  public typealias Reactor = ProfileEditMBTIReactor
  
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
    print("해제됨: ProfileEditMBTIModal")
  }
}

extension ProfileEditMBTIModal: ReactorKit.View {
  public func bind(reactor: ProfileEditMBTIReactor) {
    mainView.touchEventRelay
      .bind(with: self) { owner, event in
        switch event {
        case .cancel:
          owner.delegate?.dismissModal()
        case .change:
          owner.reactor?.action.onNext(.tabChangeButton)
        case .toggleMBTI(let mbti, let state):
          owner.reactor?.action.onNext(.toggleMBTI(mbti, state))
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.mbti)
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, mbti in
        owner.mainView.updateMBTIView(mbti)

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

extension ProfileEditMBTIModal {
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
