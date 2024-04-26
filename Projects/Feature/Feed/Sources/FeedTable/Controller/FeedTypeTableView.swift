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


final class FeedTypeTableView: BaseController {
  // MARK: - View Property
  private var tableView: UITableView = UITableView()
  private let refreshControl: UIRefreshControl = UIRefreshControl()
  private lazy var emptyFeedView: EmptyFeedView = EmptyFeedView()
  
  // MARK: - Reactor Property
  typealias Reactor = FeedTypeTableReactor
    
  // MARK: - Life Method
  override func viewDidLoad() {
    super.viewDidLoad()
    reactor?.action.onNext(.viewDidLoad)
  }
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  enum TouchEventType {
    case pushToWriteFeed
    case popToFeedMain
  }
  
  // MARK: - Initialize Method
  required init(reactor: Reactor) {
    defer {
      self.reactor = reactor
    }
    super.init()
  }

  
  // MARK: - UIConfigurable
  override func configureUI() {
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
      .withUnretained(self)
      .map { owner, _ in
        switch owner.reactor?.currentState.feedType {
        case .savedFeed:
          return TouchEventType.popToFeedMain
        default:
          return TouchEventType.pushToWriteFeed
        }
      }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.newPageItemCount)
      .distinctUntilChanged()
      .bind(with: self) { owner, pageItemCount in
        let feedType = reactor.currentState.feedType
        switch feedType {
        case .wirtedFeed, .savedFeed:
          let isShowing = reactor.currentState.feeds.isEmpty
          owner.setupEmptyView(feedListType: feedType, isShowing: isShowing)
        default:
          print("")
        }
        
        guard let pageItemCount else { return }
        switch pageItemCount {
        case 0, -1:
          owner.tableView.reloadData()
        default:
          owner.tableView.reloadRows(at: reactor.newPageIndexPath, with: .automatic)
        }
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
    
    reactor.state
      .map(\.isLoading)
      .distinctUntilChanged()
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

extension FeedTypeTableView: UITableViewDataSource {
  
//  func numberOfSections(in tableView: UITableView) -> Int {
//    return/* dataSource.count*/
//  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reactor?.currentState.feeds.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.cellId, for: indexPath) as? FeedTableViewCell else { return UITableViewCell() }
    if let reactor {
      let feedData = reactor.currentState.feeds[indexPath.row]
      cell.setData(feedData: feedData)
    }
    
    cell.touchEventRelay
      .bind(with: self) { owner, event in
        switch event {
        case .showDetail(let postId):
          owner.reactor?.action.onNext(.showDetail(postId: postId))
          print("showDetail - \(postId)")
        case .report(let userId):
          owner.reactor?.action.onNext(.report(userId: userId))
          print("report - \(userId)")
        case .bookmark(let postId):
          owner.reactor?.action.onNext(.bookmark(postId: postId))
          print("bookmark - \(postId)")
        case .favorite(let postId):
          owner.reactor?.action.onNext(.favorite(postId: postId))
          print("favorite - \(postId)")
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
  }
  
  private func registerCell() {
    tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.cellId)
  }
  
  private func setupRefreshControl() {
    tableView.refreshControl = refreshControl
  }
  
  private func setupEmptyView(feedListType: FeedListType, isShowing: Bool) {
    if isShowing {
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
