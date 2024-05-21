//
//  FeedChatModalController.swift
//  FeatureFeed
//
//  Created by 윤지호 on 5/20/24.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import SharedDesignSystem
import ReactorKit

import DomainChatInterface
import DomainChat

protocol FeedChatModalControllerDelegate: AnyObject {
  func dismiss()
  func startChatting(chatRoom: ChatRoom)
}

final class FeedChatModalController: BaseController {
  // MARK: - View Property
  private lazy var mainView = FeedChatModalView()
  
  // MARK: - Reactor Property
  public typealias Reactor = FeedChatModalReactor
  
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
  
  weak var delegate: FeedChatModalControllerDelegate?
  
  public override func configureUI() {
    view.addSubview(mainView)
    
    mainView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
    }
  }
  
  deinit {
    print("해제됨: FeedChatModalController")
  }
}

extension FeedChatModalController: ReactorKit.View {
  public func bind(reactor: FeedChatModalReactor) {
    mainView.touchEventRelay
      .bind(with: self) { owner, event in
        switch event {
        case .cancel:
          owner.delegate?.dismiss()
        case .startChat:
          owner.reactor?.action.onNext(.tabChangeButton)
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.someoneProfile)
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, someoneProfile in
        guard let someoneProfile else { return }
        owner.mainView.updateSomeoneProfile(profile: someoneProfile)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.createdChatRoom)
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, createdChatRoom in
        guard let createdChatRoom else { return }
        owner.delegate?.startChatting(chatRoom: createdChatRoom)
        
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

extension FeedChatModalController {
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


