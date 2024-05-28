//
//  FeedMainController.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/15/24.
//

import UIKit
import SharedDesignSystem
import DomainCommunityInterface

import SnapKit
import RxSwift
import RxCocoa
import ReactorKit

protocol FeedMainControllerDelegate: AnyObject {
  func pushToDetailView(postId: Int)
  func pushToNotificationView()
  func pushToFeedProfileView()
  func presentFeedWriteModal()
  func presentReportModal(userId: Int)
  
  func presentStartChatModal(receiverId: Int)
}

final class FeedMainController: BaseController {
  // MARK: - View Property
  private let segumentButtonView: FeedMainSegmentView = FeedMainSegmentView()
  private let mainView: FeedMainPageViewController
  private let writeFeedButton: WriteFeedButton = WriteFeedButton().then {
    $0.backgroundColor = SystemColor.primaryNormal.uiColor
    $0.layer.cornerRadius = 43 / 2
    $0.clipsToBounds = true
  }
    
  // MARK: - Reactor Property
  typealias Reactor = FeedMainReactor
  
  // MARK: - Delegate
  weak var delegate: FeedMainControllerDelegate?
  
  // MARK: - Life Method
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = false
  }
  
  // MARK: - Initialize Method
  required init(reactor: Reactor, FeedMainPageViewController: FeedMainPageViewController) {
    defer {
      self.reactor = reactor
    }
    self.mainView = FeedMainPageViewController
    super.init()
  }
  
  deinit {
    print("해제됨: FeedMainController")
  }
  
   // MARK: - UIConfigurable
  override func configureUI() {
    setView()
  }
  
  /// notification 주석
  override func setNavigationBar() {
    let feedProfileButton = CustomNavigationBarButton(image: Images.feedProfile.image)
    let bellButton = CustomNavigationBarButton(image: Images.bell.image)
   
    customNavigationController?.customNavigationBarConfig = CustomNavigationBarConfiguration(
      titleView: .init(title: "피드"),
      titleAlignment: .leading,
      rightButtons: [feedProfileButton/*, bellButton*/]
    )
    customNavigationController?.navigationBarEvents(of: BarTouchEvent.self)
      .bind(with: self) { owner, event in
        switch event {
//        case .notification:
//          owner.delegate?.pushToNotificationView()
        case .feedProfile:
          owner.delegate?.pushToFeedProfileView()
        }
      }
      .disposed(by: disposeBag)
  }
  
  enum BarTouchEvent: Int, IntCaseIterable {
    case feedProfile
//    case notification
  }
}

extension FeedMainController: ReactorKit.View {
  func bind(reactor: FeedMainReactor) {
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
        case .presentReportModal(userId: let userId):
          owner.delegate?.presentReportModal(userId: userId)
        case .pushToWriteFeed:
          owner.delegate?.presentFeedWriteModal()
        case .pushToDetailView(postId: let postId):
          owner.delegate?.pushToDetailView(postId: postId)
        case .presentStartChatModal(let receiverId):
          owner.delegate?.presentStartChatModal(receiverId: receiverId)
        case .none:
          return
        }
      }
      .disposed(by: disposeBag)
    
    writeFeedButton.touchEventRelay
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, _ in
        owner.delegate?.presentFeedWriteModal()
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.pageIndex)
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, index in
        owner.segumentButtonView.setIndex(index)
        owner.mainView.setPageIndex(index)
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

extension FeedMainController {
  private func setView() {
    self.view.addSubview(segumentButtonView)
    self.addChild(mainView)
    self.view.addSubview(mainView.view)
    self.view.addSubview(writeFeedButton)
    
    segumentButtonView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(52)
      $0.height.equalTo(44)
      $0.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    mainView.view.snp.makeConstraints {
      $0.top.equalTo(segumentButtonView.snp.bottom)
      $0.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    writeFeedButton.snp.makeConstraints {
      $0.width.equalTo(96)
      $0.height.equalTo(43)
      $0.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(103)
    }
  }
}

extension FeedMainController {
  func refreshRecentFeeds(postId: Int) {
    mainView.refreshRecentFeeds(postId: postId)
  }
}
