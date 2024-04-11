//
//  ProfileEditAddressModal.swift
//  FeatureProfile
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

final class ProfileEditAddressModal: BaseController {
  // MARK: - View Property
  private lazy var mainView = ProfileEditAddressView()
  
  // MARK: - Reactor Property
  public typealias Reactor = ProfileEditAddressReactor
  
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
    print("해제됨: ProfileEditAddressModal")
  }
}

extension ProfileEditAddressModal: ReactorKit.View {
  public func bind(reactor: ProfileEditAddressReactor) {
    mainView.touchEventRelay
      .bind(with: self) { owner, event in
        switch event {
        case .cancel:
          owner.delegate?.dismissModal()
        case .change:
          owner.reactor?.action.onNext(.tabChangeButton)
        case .selectAddress(let address):
          owner.reactor?.action.onNext(.selectAddress(address))
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.addressArray)
      .filter { !$0.isEmpty }
      .distinctUntilChanged()
      .bind(to: mainView.items)
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.selectedAddress)
      .distinctUntilChanged()
      .bind(with: self) { owner, selectedAddress in
        if let selectedAddress {
          owner.mainView.setButtonState(selectedAddress: selectedAddress)
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
          owner.delegate?.successEdit(editType: .address)
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

      }
      .disposed(by: disposeBag)
    
  }
}

extension ProfileEditAddressModal {
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
