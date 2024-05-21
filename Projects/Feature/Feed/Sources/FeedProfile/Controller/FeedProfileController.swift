//
//  FeedProfileController.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/26/24.
//

import UIKit
import SharedDesignSystem

import SnapKit
import RxSwift
import RxCocoa
import ReactorKit

protocol FeedProfileControllerDelegate: AnyObject {
  func pushToDetailView(postId: Int)
  func popToFeedMain()
  func presentFeedWriteModal()
  func presentReportModal(userId: Int)
  
  func presentStartChatModal(receiverId: Int)
}

final class FeedProfileController: BaseController {
  // MARK: - View Property
  private let segumentButtonView: FeedProfileSegmentView = FeedProfileSegmentView()
  private let mainView: FeedProfilePageViewController
  
  // MARK: - Reactor Property
  typealias Reactor = FeedProfileReactor
  
  // MARK: - Delegate
  weak var delegate: FeedProfileControllerDelegate?
  
  // MARK: - Life Method
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = false
  }
  
  // MARK: - Initialize Method
  required init(reactor: Reactor, feedProfilePageViewController: FeedProfilePageViewController) {
    defer {
      self.reactor = reactor
    }
    self.mainView = feedProfilePageViewController
    super.init()
  }
  
  deinit {
    print("해제됨: FeedProfileController")
  }
  
   // MARK: - UIConfigurable
  override func configureUI() {
    setView()
  }
   
  override func setNavigationBar() {
    customNavigationController?.customNavigationBarConfig = CustomNavigationBarConfiguration(
      titleView: .init(title: "내 활동"),
      titleAlignment: .center
    )
  }
}

extension FeedProfileController: ReactorKit.View {
  func bind(reactor: FeedProfileReactor) {
    segumentButtonView.touchEventRelay
      .bind(with: self) { owner, index in
        owner.reactor?.action.onNext(.changePage(index))
      }
      .disposed(by: disposeBag)
    
    mainView.touchEventRelay
      .bind(with: self) { owner, event in
        switch event {
        case .changePage(let index):
          owner.reactor?.action.onNext(.changePage(index))
        case .pushToWriteFeed:
          owner.delegate?.presentFeedWriteModal()
        case .popToFeedMain:
          owner.delegate?.popToFeedMain()
        case .presentReportModal(userId: let userId):
          owner.delegate?.presentReportModal(userId: userId)
        case .pushToDetailView(postId: let postId):
          owner.delegate?.pushToDetailView(postId: postId)
        case .presentStartChatModal(let receiverId):
          owner.delegate?.presentStartChatModal(receiverId: receiverId)
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.pageIndex)
      .bind(with: self) { owner, index in
        owner.segumentButtonView.setIndex(index)
        owner.mainView.setPageIndex(index)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.isWrited)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, isWrited in
        if isWrited {
          owner.mainView.refreshWriedView()
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

extension FeedProfileController {
  private func setView() {
    self.view.addSubview(segumentButtonView)
    self.addChild(mainView)
    self.view.addSubview(mainView.view)
    
    segumentButtonView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(52)
      $0.height.equalTo(44)
      $0.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    mainView.view.snp.makeConstraints {
      $0.top.equalTo(segumentButtonView.snp.bottom)
      $0.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    
  }
}
