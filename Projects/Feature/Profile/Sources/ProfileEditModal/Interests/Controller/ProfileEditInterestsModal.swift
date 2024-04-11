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

final class ProfileEditInterestsModal: BaseController {
  // MARK: - View Property
  private lazy var mainView = ProfileEditInterestsView()
  
  // MARK: - Reactor Property
  public typealias Reactor = ProfileEditInterestsReactor
  
  // MARK: - LifeCycle Method
  public override func viewDidLoad() {
    super.viewDidLoad()
    reactor?.action.onNext(.viewDidLoad)
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
    print("해제됨: ProfileEditInterestsModal")
  }
}

extension ProfileEditInterestsModal: ReactorKit.View {
  public func bind(reactor: ProfileEditInterestsReactor) {
    mainView.touchEventRelay
      .bind(with: self) { owner, event in
        switch event {
        case .cancel:
          owner.delegate?.dismissModal()
        case .change:
          owner.reactor?.action.onNext(.tabChangeButton)
        case .tabTag(let tag):
          owner.reactor?.action.onNext(.tabTag(tag))
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.Allinterests)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, tags in
        owner.mainView.updateInterestCollectionView(tags)
        owner.mainView.updateInterestCollectionCell(reactor.currentState.interest)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.interest)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, tags in
        owner.mainView.updateInterestCollectionCell(tags)
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

extension ProfileEditInterestsModal {
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
