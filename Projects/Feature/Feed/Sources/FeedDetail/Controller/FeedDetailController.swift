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
  private lazy var refreshControl: UIRefreshControl = UIRefreshControl()
  private lazy var commentInputBar: CommentInputBar = CommentInputBar()
  private lazy var emptyFooterView: UILabel = UILabel().then {
    $0.textAlignment = .center
    $0.text = "현재 댓글이 없어요."
    $0.font = SystemFont.body03.font
    $0.textColor = SystemColor.gray500.uiColor
    
    let width = CGRect.appFrame.width
    $0.frame = CGRect(x: 0, y: 0, width: width, height: 80)
  }
  private lazy var loadingFooterView: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: CGRect.appFrame.width, height: 100))
  
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
  
  private func showInputCancelAlert() {
    let alertView = CustomAlertView().then {
      $0.title = "입력 취소"
      $0.subTitle = "작성을 취소 하시겠어요?"
    }
    alertView.addButton("확인", for: .positive)
    alertView.addButton("취소", for: .negative)
    
    let alertController = CustomAlertController(alertView: alertView, delegate: self)
    navigationController?.present(alertController, animated: false)
  }
  
  public override func destructiveAction() {
    reactor?.action.onNext(.startComment(.cancel))
    tableView.endEditing(true)
  }
}

extension FeedDetailController: ReactorKit.View {
  func bind(reactor: FeedDetailReactor) {
    refreshControl.rx.controlEvent(.valueChanged)
      .bind(with: self) { owner, _ in
        owner.reactor?.action.onNext(.refresh)
      }
      .disposed(by: disposeBag)
    
    commentInputBar.touchEventRelay
      .bind(with: self) { owner, event in
        guard let reactor = owner.reactor else { return }
        switch event {
        case .startEdit:
          switch reactor.currentState.commentInputType {
          case .cancel, .none:
            reactor.action.onNext(.startComment(.comment))
          default:break
          }
        case .tabSendButton:
          reactor.action.onNext(.sendComment)
        }
      }
      .disposed(by: disposeBag)
    
    commentInputBar.inputEventRelay
      .bind(with: self) { owner, text in
        owner.reactor?.action.onNext(.inputComment(text))
      }
      .disposed(by: disposeBag)
    
    
    reactor.state
      .map(\.feed?.postId)
      .distinctUntilChanged()
      .bind(with: self) { owner, _ in
        guard owner.reactor?.currentState.feed != nil else { return }
        owner.tableView.reloadData()
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.comments.count)
      .distinctUntilChanged()
      .bind(with: self) { owner, count in
        if count < 1 {
          owner.tableView.tableFooterView = owner.emptyFooterView
        } else {
          owner.tableView.tableFooterView = UIView()
        }
      }
      .disposed(by: disposeBag)
    
    
    reactor.state
      .map(\.commentTableState)
      .distinctUntilChanged()
      .bind(with: self) { owner, type in
        guard let type else { return }
        switch type {
        case .savedcomment:
          owner.tableView.reloadData()
          owner.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
          owner.setupFooterView(footerType: .loadingComments)
          
        case .savedReply(let commentId):
          if let index = owner.reactor?.currentState.comments.firstIndex(where: { $0.commentId == commentId }),
            let cell = owner.tableView.cellForRow(at: IndexPath(row: index, section: 1)) as? FeedCommentCell {
            cell.updateReplyStackView()
          }
        case .commentLoaded:
          owner.tableView.reloadData()
          owner.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
          owner.setupFooterView(footerType: .loadingComments)
          
        case .commentLoadedLastPage:
          owner.tableView.reloadData()
          owner.tableView.tableFooterView = UIView(frame: .zero)
          owner.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
          owner.setupFooterView(footerType: .lastCommentPage)

        case .commentLoadedEmpty:
          owner.tableView.reloadData()
          owner.tableView.tableFooterView = UIView(frame: .zero)
          owner.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
          owner.setupFooterView(footerType: .loadingComments)
          
        case .commentPaged(let addedCount):
          owner.tableView.insertRows(at: owner.reactor?.newPageIndexPath ?? [], with: .automatic)
          owner.setupFooterView(footerType: .loadingComments)
          
        case .commentlastPage:
          owner.setupFooterView(footerType: .lastCommentPage)
        case .error:
          return
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.commentInputType)
      .distinctUntilChanged()
      .bind(with: self) { owner, type in
        guard let type else { return }
        switch type {
        case .comment:
          owner.tableView.reloadSections(IndexSet(integer: 1), with: UITableView.RowAnimation.automatic)
        case .reply(let commentId):
          if let index = owner.reactor?.currentState.comments.firstIndex(where: { $0.commentId == commentId }) {
            owner.tableView.scrollToRow(at: IndexPath(row: index, section: 1), at: .middle, animated: true)
          }
        case .cancel:
          owner.commentInputBar.updateToCanceledState()
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.inputedText)
      .distinctUntilChanged()
      .bind(with: self) { owner, text in
        let isEnabled: Bool = text.isEmpty || owner.commentInputBar.isEditing == false ? false : true
        owner.commentInputBar.updateSendButtonIsEnabled(isEnabled)
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
      return reactor.currentState.comments.count
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
            return
          case .comment:
            return
          case .bookmark(let postId, let changedState):
            owner.reactor?.action.onNext(.bookmark(postId: postId, changedState: changedState))
          case .favorite(let postId, let changedState):
            owner.reactor?.action.onNext(.favorite(postId: postId, changedState: changedState))
          }
        }
        .disposed(by: cell.disposeBag)
      
      return cell
    case .comment:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCommentCell.cellId, for: indexPath) as? FeedCommentCell else { return UITableViewCell() }
      
      let comment = reactor.currentState.comments[indexPath.row]
      cell.setDate(comment: comment)
      
      cell.touchEventRelay
        .bind(with: self) { owner, event in
          switch event {
          case .report(let commentId):
            owner.presentAlert(userId: commentId)
          case .commentLike:
            print("")
          case .commentReply:
            print("")
          case .replylike:
            print("")
          case .getReplyPage(let commentId):
            owner.reactor?.action.onNext(.startComment(.reply(commentId: commentId)))
          }
        }
        .disposed(by: cell.disposeBag)
      
      return cell
    }
  }
}

extension FeedDetailController: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
      return false
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    switch reactor?.currentState.commentInputType {
    case .comment, .reply:
      showInputCancelAlert()
    default:break
    }
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let reactor else { return }
    let height: CGFloat = scrollView.frame.size.height
    let contentYOffset: CGFloat = scrollView.contentOffset.y
    let scrollViewHeight: CGFloat = scrollView.contentSize.height
    let distanceFromBottom: CGFloat = scrollViewHeight - contentYOffset

    
    if distanceFromBottom < height && reactor.currentState.isFetchingComment == false {
      switch reactor.currentState.commentTableState {
      case .savedcomment, .commentLoaded, .commentPaged:
        reactor.action.onNext(.scrollToNextPage)
      default:
        return
      }
    }
  }
}

extension FeedDetailController {
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UITableView.automaticDimension
    tableView.separatorStyle = .singleLine
    tableView.separatorInset = .zero
    tableView.separatorColor = SystemColor.gray100.uiColor
    
    registerCell()
    setupRefreshControl()
      
    self.view.addSubview(tableView)
    self.view.addSubview(commentInputBar)

    tableView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(52)
      $0.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(60)
    }
    
    commentInputBar.snp.makeConstraints {
      $0.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(60)
    }
  }
  
  private func registerCell() {
    tableView.register(FeedDetailCell.self, forCellReuseIdentifier: FeedDetailCell.cellId)
    tableView.register(FeedCommentCell.self, forCellReuseIdentifier: FeedCommentCell.cellId)
  }
  
  private func setupRefreshControl() {
    tableView.refreshControl = refreshControl
  }
  
  private func setupFooterView(footerType: CommentFooterType) {
    loadingFooterView.stopAnimating()
    switch footerType {
    case .loadingComments:
      loadingFooterView.startAnimating()
      tableView.tableFooterView = loadingFooterView
    case .emptyComments:
      tableView.tableFooterView = emptyFooterView
    case .lastCommentPage:
      tableView.tableFooterView = UIView(frame: .zero)
    }
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
