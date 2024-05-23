//
//  FeedDetailController.swift
//  FeatureFeed
//
//  Created by 윤지호 on 5/3/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import ReactorKit

import SharedDesignSystem
import DomainCommunityInterface

protocol FeedDetailControllerDelegate: AnyObject {
  func presentReportModal(userId: Int)
}

final class FeedDetailController: BaseController {
  // MARK: - View Property
  private var tableView: UITableView = UITableView()
  
  // MARK: - Reactor Property
  typealias Reactor = FeedDetailReactor
  
  // MARK: - Delegate
  weak var delegate: FeedDetailControllerDelegate?
  
  // MARK: - Life Method
  override func viewDidLoad() {
    super.viewDidLoad()
    reactor?.action.onNext(.viewDidLoad)
  }
  
  // MARK: - Initialize Method
  required init(reactor: Reactor) {
    defer {
      self.reactor = reactor
    }
    super.init()
  }
  
  deinit {
    print("해제됨: FeedDetailController")
  }
  
  // MARK: - UIConfigurable
  override func configureUI() {
    setView()
  }
  
  override func setNavigationBar() {
    customNavigationController?.customNavigationBarConfig = CustomNavigationBarConfiguration(
      titleView: .init(title: "게시글")
    )
  }
}

extension FeedDetailController: ReactorKit.View {
  func bind(reactor: FeedDetailReactor) {
    reactor.state
      .map(\.feed?.postId)
      .distinctUntilChanged()
      .bind(with: self) { owner, _ in
        guard owner.reactor?.currentState.feed != nil else { return }
        owner.tableView.reloadData()
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


extension FeedDetailController {
  private func setView() {
    tabBarController?.tabBar.isHidden = true
    
    setupTableView()
  }
}

extension FeedDetailController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    guard let reactor else { return 2 }
    return reactor.cellCase.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let reactor else { return 0 }
    
    switch reactor.cellCase[section] {
    case .content:
      return 1
    case .comment:
      return 1
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let reactor else { return UITableViewCell() }
    
    switch reactor.cellCase[indexPath.section] {
    case .content:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedDetailCell.cellId, for: indexPath) as? FeedDetailCell else { return UITableViewCell() }
      cell.disposeBag = DisposeBag()
      
      if let feed = reactor.currentState.feed {
        cell.setData(feedData: feed)
      }
      
      cell.touchEventRelay
        .bind(with: self) { owner, event in
          switch event {
          case .report(let userId):
            owner.presentAlert(userId: userId)
          case .images:
            print("show Images")
          case .comment:
            return
          case .bookmark(let postId, let changedState):
            print("bookmark ==> \(changedState)")
            owner.reactor?.action.onNext(.bookmark(postId: postId, changedState: changedState))
          case .favorite(let postId, let changedState):
            print("favorite ==> \(changedState)")
            owner.reactor?.action.onNext(.favorite(postId: postId, changedState: changedState))
          }
        }
        .disposed(by: cell.disposeBag)
      
      return cell
    case .comment:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCommentCell.cellId, for: indexPath) as? FeedCommentCell else { return UITableViewCell() }
      return cell
    }
  }
}

extension FeedDetailController: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
      return false
  }
}

extension FeedDetailController {
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UITableView.automaticDimension
    tableView.separatorStyle = .none
    
    registerCell()
      
    self.view.addSubview(tableView)
    tableView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(52)
      $0.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
  
  private func registerCell() {
    tableView.register(FeedDetailCell.self, forCellReuseIdentifier: FeedDetailCell.cellId)
    tableView.register(FeedCommentCell.self, forCellReuseIdentifier: FeedCommentCell.cellId)
  }
}

extension FeedDetailController {
  private func presentAlert(userId: Int) {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let declaration = UIAlertAction(title: "신고", style: .default) { [weak self] action in
      self?.delegate?.presentReportModal(userId: userId)
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
