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
  
  
  // MARK: - Reactor Property
  typealias Reactor = FeedTypeTableReactor
  
  
  // MARK: - Life Method
  override func viewDidLoad() {
    super.viewDidLoad()
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
  }
  
  deinit {
    print("해제됨: FeedTypeTableView")
  }
}

extension FeedTypeTableView: ReactorKit.View {
  func bind(reactor: FeedTypeTableReactor) {
    reactor.state
      .map(\.feeds)
      .bind(with: self) { owner, feeds in
        owner.tableView.reloadData()
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
  
}
