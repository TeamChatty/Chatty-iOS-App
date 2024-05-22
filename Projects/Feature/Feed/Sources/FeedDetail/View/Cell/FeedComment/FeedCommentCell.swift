//
//  FeedCommentCell.swift
//  FeatureFeed
//
//  Created by 윤지호 on 5/3/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

import SharedDesignSystem
import SharedUtil
import DomainCommunityInterface

final class FeedCommentCell: UITableViewCell, Touchable {
  static let cellId: String = "FeedCommentCell"
  
  // MARK: - View Property
  private let contentSection: FeedCommentView = FeedCommentView()
  private let replySection: UIStackView = UIStackView().then {
    $0.axis = .vertical
  }
  private let replyButton: ReplyButton = ReplyButton().then {
    typealias Configuration = ReplyButton.Configuration
    let enabled = Configuration(arrowImage: Images.smallVArrowUp.image)
    let disabled = Configuration(arrowImage: Images.smallVArrowDown.image)

    $0.setState(enabled, for: .enabled)
    $0.setState(disabled, for: .disabled)
  }
  private let moreReplyPageButton: ReplyButton = ReplyButton().then {
    typealias Configuration = ReplyButton.Configuration
    let enabled = Configuration(arrowImage: Images.smallVArrowDown.image)

    $0.setState(enabled, for: .enabled)
    $0.currentState = .enabled
  }
  
  
  // MARK: - Stored Property
  private var commentId: Int?
  
  // MARK: - Rx Property
  var disposeBag = DisposeBag()
  private let cellDisposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  
  // MARK: - Initialize Method
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
    prepareForReuseReplyView()
  }

  // MARK: - UIConfigurable
  private func configureUI() {
    setView()
  }
  
  // MARK: - UIBindable
  private func bind() {
    replyButton.touchEventRelay
      .map { [weak self] _ in
        if self?.replyButton.currentState == .enabled {
          return TouchEventType.getReplies(commentId: self?.commentId ?? 0)
        } else {
          return TouchEventType.removeReplies(commentId: self?.commentId ?? 0)
        }
      }
      .bind(to: touchEventRelay)
      .disposed(by: cellDisposeBag)
    
    moreReplyPageButton.touchEventRelay
      .map { [weak self] _ in
        return TouchEventType.getRepliesPage(commentId: self?.commentId ?? 0)
      }
      .bind(to: touchEventRelay)
      .disposed(by: cellDisposeBag)
    
    contentSection.touchEventRelay
      .map { event in
        switch event {
        case .report(let commentId):
          return TouchEventType.report(commentId: commentId)
        case .reply(let commentId):
          return TouchEventType.commentReply(commentId: commentId)
        case .like(_, let commentId, let changedState):
          return TouchEventType.commentLike(commentId: commentId, changedState: changedState)
        }
      }
      .bind(to: touchEventRelay)
      .disposed(by: cellDisposeBag)
  }
}

extension FeedCommentCell {
  enum TouchEventType {
    /// comment
    case report(commentId: Int)
    case commentLike(commentId: Int, changedState: Bool)
    case commentReply(commentId: Int)
    
    /// reply
    case replylike(parentId: Int, replyId: Int, changedState: Bool)
    case getReplies(commentId: Int)
    case getRepliesPage(commentId: Int)
    case removeReplies(commentId: Int)
  }
}

/// SetView
extension FeedCommentCell {
  private func setView() {
    contentView.addSubview(contentSection)
    contentView.addSubview(replySection)
    
    contentSection.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.height.greaterThanOrEqualTo(30)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    replySection.snp.makeConstraints {
      $0.top.equalTo(contentSection.snp.bottom)
      $0.leading.equalToSuperview().inset(59)
      $0.trailing.equalToSuperview().inset(20)
      $0.height.greaterThanOrEqualTo(1)
      $0.bottom.equalToSuperview()
    }
  }
}

extension FeedCommentCell {
  private func prepareForReuseReplyView() {
    for arrangedSubview in replySection.arrangedSubviews  {
      arrangedSubview.removeFromSuperview()
    }
    replySection.removeAllArrangedSubViews()
  }
}

extension FeedCommentCell {
  public func setDate(comment: FeedDetailComment) {
    self.commentId = comment.commentId
    contentSection.updateData(isOwner: comment.isOwner, isReply: comment.isReply, parentsId: nil, commentId: comment.commentId, profileImage: comment.profileImage, nickname: comment.nickname, content: comment.content, createdAt: comment.createdAt, isLike: comment.isLike, likeCount: comment.likeCount)
    
    updateReplyStackView(childCount: comment.childCount, childReplys: comment.childReplys)
  }
  
  private func updateReplyStackView(childCount: Int, childReplys: [FeedDetailReply]) {
    if childCount > 0 {
      replySection.addArrangedSubview(replyButton)
      replyButton.frame = CGRect(x: 0, y: 0, width: 150, height: 20)
      
      if childReplys.isEmpty {
        replyButton.currentState = .enabled
        replyButton.title = "답글 \(childCount)개 보기"
      } else {
        replyButton.currentState = .disabled
        replyButton.title = "답글 닫기"
      }
      
      for reply in childReplys {
        let replyView: FeedCommentView = FeedCommentView()
        
        let width = CGRect.appFrame.width - 79
        replyView.snp.makeConstraints {
          $0.width.equalTo(width)
          $0.height.greaterThanOrEqualTo(50)
        }
        
        replyView.updateData(
          isOwner: reply.isOwner,
          isReply: reply.isReply,
          parentsId: reply.parentsId,
          commentId: reply.commentId,
          profileImage: reply.profileImage,
          nickname: reply.nickname,
          content: reply.content,
          createdAt: reply.createdAt.toTimeDifference(),
          isLike: reply.isLike,
          likeCount: reply.likeCount
        )
        
        replySection.addArrangedSubview(replyView)
        replyView.touchEventRelay
          .map { event in
            switch event {
            case .report(let commentId):
              return TouchEventType.report(commentId: commentId)
            case .reply(let commentId):
              return TouchEventType.commentReply(commentId: commentId)
            case .like(let parentId, let replyId, let changedState):
              return TouchEventType.replylike(parentId: parentId ?? 0, replyId: replyId, changedState: changedState)
            }
          }
          .bind(to: touchEventRelay)
          .disposed(by: cellDisposeBag)
      }
      
      
      if childReplys.isEmpty == false && childReplys.count < childCount {
        replySection.addArrangedSubview(moreReplyPageButton)
        moreReplyPageButton.title = "답글 더보기"
      }
      
    }
  }
  
  func updateChildCount(count: Int) {
    if replyButton.currentState == .enabled {
      replyButton.title = "답글 \(count)개 보기"
    }
  }
}
