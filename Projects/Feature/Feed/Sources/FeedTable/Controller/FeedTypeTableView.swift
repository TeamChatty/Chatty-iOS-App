//
//  FeedTypeTableView.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/19/24.
//


import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import ReactorKit

import SharedDesignSystem
import DomainCommunityInterface


final class FeedTypeTableView: UIViewController {
  // MARK: - View Property
  private var tableView: UITableView = UITableView()
  private let refreshControl: UIRefreshControl = UIRefreshControl()
  private lazy var emptyFeedView: EmptyFeedView = EmptyFeedView()
  private let footerView: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: CGRect.appFrame.width, height: 100))
  
  // MARK: - Reactor Property
  typealias Reactor = FeedTypeTableReactor
    
  // MARK: - Life Method
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  var disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  enum TouchEventType {
    case pushToDetailView(postId: Int)
    case pushToWriteFeed
    case popToFeedMain
    case presentReportModal(userId: Int)
    case presentStartChatModal(receiverId: Int)
  }
  
  // MARK: - Initialize Method
  required init(reactor: Reactor) {
    defer {
      self.reactor = reactor
      reactor.action.onNext(.viewDidLoad)
    }
    super.init(nibName: nil, bundle: nil)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - UIConfigurable
  private func configureUI() {
    setTableView()
    setupRefreshControl()
  }
  
  deinit {
    print("해제됨: FeedTypeTableView")
  }
  
}

extension FeedTypeTableView: ReactorKit.View {
  func bind(reactor: FeedTypeTableReactor) {
    refreshControl.rx.controlEvent(.valueChanged)
      .bind(with: self) { owner, _ in
        owner.reactor?.action.onNext(.refresh)
      }
      .disposed(by: disposeBag)
    
    emptyFeedView.touchEventRelay
      .bind(with: self) { owner, _ in
        guard let reactor = owner.reactor else { return }
        switch reactor.currentState.feedType {
        case .recent, .topLiked:
          owner.reactor?.action.onNext(.refresh)
        case .myBookmark:
          owner.touchEventRelay.accept(.popToFeedMain)
        case .myPosts:
          owner.touchEventRelay.accept(.pushToWriteFeed)
        case .myComments:
          return
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.tableState)
      .distinctUntilChanged()
      .bind(with: self) { owner, tableState in
        guard let tableState else { return }
        switch tableState {
        case .loaded:
          owner.tableView.reloadData()
          owner.tableView.tableFooterView = owner.footerView
          owner.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
          owner.setupEmptyView()

        case .loadedLastPage:
          owner.tableView.reloadData()
          owner.tableView.tableFooterView = UIView(frame: .zero)
          owner.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
          owner.setupEmptyView()

        case .loadedEmpty:
          owner.tableView.reloadData()
          owner.tableView.tableFooterView = UIView(frame: .zero)
//          owner.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
          owner.setupEmptyView(feedListType: owner.reactor?.currentState.feedType)

        case .paged:
          owner.tableView.insertRows(at: owner.reactor?.newPageIndexPath ?? [], with: .automatic)
                  
        case .lastPage:
          owner.tableView.tableFooterView = UIView(frame: .zero)
        default:
          return
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.blockedIndexs)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, blockedIndexs in
        guard let blockedIndexs else { return }
        let indexPaths = blockedIndexs.map { IndexPath(row: $0, section: 0) }
        owner.tableView.deleteRows(at: indexPaths, with: .fade)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.reportedIdIndex)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, reportedIdIndex in
        guard let reportedIdIndex else { return }
        owner.tableView.deleteRows(at: [IndexPath(row: reportedIdIndex, section: 0)], with: .fade)
      }
      .disposed(by: disposeBag)

    reactor.state
      .map(\.isReloading)
      .distinctUntilChanged()
      .bind(with: self) { owner, isReloading in
        if isReloading == false {
          DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            owner.refreshControl.endRefreshing()
          })
        }
      }
      .disposed(by: disposeBag)
  }
}

extension FeedTypeTableView: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let reactor else { return 0 }
    return reactor.currentState.feeds.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let reactor,
          let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.cellId, for: indexPath) as? FeedTableViewCell else { return UITableViewCell() }
    let feedData = reactor.currentState.feeds[indexPath.row]
    cell.setData(feedData: feedData)
    
    cell.touchEventRelay
      .bind(with: self) { owner, event in
        switch event {
        case .showDetail(let postId):
          owner.touchEventRelay.accept(.pushToDetailView(postId: postId))
          
        case .report(let userId):
          owner.presentAlert(userId: userId)
        case .bookmark(let postId, let changedState):
          owner.reactor?.action.onNext(.bookmark(postId: postId, changedState: changedState))
        case .favorite(let postId, let changedState):
          owner.reactor?.action.onNext(.favorite(postId: postId, changedState: changedState))
          
        case .tabProfileImage(let receiverId):
          owner.touchEventRelay.accept(.presentStartChatModal(receiverId: receiverId))
        }
      }
      .disposed(by: cell.disposeBag)
    return cell
  }
}

extension FeedTypeTableView: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
      return false
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let reactor else { return }
    let height: CGFloat = scrollView.frame.size.height
    let contentYOffset: CGFloat = scrollView.contentOffset.y
    let scrollViewHeight: CGFloat = scrollView.contentSize.height
    let distanceFromBottom: CGFloat = scrollViewHeight - contentYOffset

    
    if distanceFromBottom < height && reactor.currentState.isFetchingPage == false {
      switch reactor.currentState.tableState {
      case .loaded, .paged:
        reactor.action.onNext(.scrollToNextPage)
      default:
        return
      }
    }
  }
}

extension FeedTypeTableView {
  private func presentAlert(userId: Int) {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let declaration = UIAlertAction(title: "신고", style: .default) { [weak self] action in
      self?.touchEventRelay.accept(.presentReportModal(userId: userId))
    }
    let block = UIAlertAction(title: "이 친구의 모든 글 차단", style: .default) { [weak self] action in
      self?.reactor?.action.onNext(.reportBlockUser(userId: userId))
    }
    let cancel = UIAlertAction(title: "취소", style: .cancel)
    
    alert.addAction(declaration)
    alert.addAction(block)
    alert.addAction(cancel)
    
    self.present(alert, animated: true)
  }
}

extension FeedTypeTableView {
  private func setTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UITableView.automaticDimension
    tableView.separatorStyle = .none
    
    registerCell()
    
    self.view.addSubview(tableView)
    tableView.snp.makeConstraints {
      $0.horizontalEdges.verticalEdges.equalToSuperview()
    }
    footerView.startAnimating()
    tableView.tableFooterView = footerView
  }
  
  private func registerCell() {
    tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.cellId)
  }
  
  private func setupRefreshControl() {
    tableView.refreshControl = refreshControl
  }
   
  private func setupEmptyView(feedListType: FeedPageType? = nil) {
    if let feedListType {
      view.addSubview(emptyFeedView)
      emptyFeedView.snp.makeConstraints {
        $0.horizontalEdges.verticalEdges.equalTo(tableView)
      }
      emptyFeedView.updateLadel(feedListType: feedListType)
    } else {
      emptyFeedView.removeFromSuperview()
    }
  }
}


extension FeedTypeTableView {
  func refreshFeeds(postId: Int) {
    reactor?.action.onNext(.refreshSuccessWrited(postId: postId))
  }
  
  func removeReportedFeed(userId: Int) {
    reactor?.action.onNext(.reportBlockUser(userId: userId))
  }
}
