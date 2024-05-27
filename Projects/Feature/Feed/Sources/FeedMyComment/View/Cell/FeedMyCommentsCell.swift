//
//  FeedMyCommentsCell.swift
//  FeatureFeed
//
//  Created by 윤지호 on 5/18/24.
//


import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

import SharedDesignSystem
import SharedUtil
import DomainCommunityInterface

final class FeedMyCommentsCell: UITableViewCell, Touchable {
  static let cellId: String = "FeedMyCommentsCell"
  
  // MARK: - View Property
  // HeaderSection
  private let contentSection: FeedMyCommentCellView = FeedMyCommentCellView()
  
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
  }

  // MARK: - UIConfigurable
  private func configureUI() {
    setView()
  }
  
  // MARK: - UIBindable
  private func bind() {
    contentSection.touchEventRelay
      .map { event in
        switch event {
        case .showPostForReply(let postId):
          return TouchEventType.showPostForReply(postId: postId)
        case .like(let commentId, let changedState):
          return TouchEventType.like(commentId: commentId, changedState: changedState)
        }
      }
      .bind(to: touchEventRelay)
      .disposed(by: cellDisposeBag)
  }
}

extension FeedMyCommentsCell {
  enum TouchEventType {
    case showPostForReply(postId: Int)
    case like(commentId: Int, changedState: Bool)
  }
}

/// SetView
extension FeedMyCommentsCell {
  private func setView() {
    contentView.addSubview(contentSection)
    
    contentSection.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.height.greaterThanOrEqualTo(30)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview()
    }
  }
}

extension FeedMyCommentsCell {
  public func setDate(comment: Comment) {
    self.commentId = comment.commentId
    contentSection.updateData(postId: comment.postId, commentId: comment.commentId, profileImage: comment.imageUrl, nickname: comment.nickname, content: comment.content, createdAt: comment.createdAt, isLike: comment.like, likeCount: comment.likeCount)
  }
}

