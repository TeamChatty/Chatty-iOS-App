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
import DomainCommunityInterface

final class FeedCommentCell: UITableViewCell, Touchable {
  static let cellId: String = "FeedCommentCell"
  
  // MARK: - View Property
  // HeaderSection
  private let contentSection: FeedCommentView = FeedCommentView()
  private let replySection: UIStackView = UIStackView()
  private let replyButton: IconTitleButton = IconTitleButton().then {
    $0.backgroundColor = .clear
  }
  
  // MARK: - Stored Property
  
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

  // MARK: - UIConfigurable
  private func configureUI() {
    setView()
  }
  
  // MARK: - UIBindable
  private func bind() {
   
  }
}

extension FeedCommentCell {
  enum TouchEventType {
    /// comment
    case report(commentId: Int)
    case commentLike(commentId: Int, changedState: Bool)
    case commentReply(commentId: Int)
    
    /// reply
    case replylike(replyId: Int, changedState: Bool)
    case getReplyPage(lastReplyId: Int)
  }
}

/// SetView
extension FeedCommentCell {
  private func setView() {
    contentView.addSubview(contentSection)
    contentView.addSubview(replySection)
    
    contentSection.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    replySection.snp.makeConstraints {
      $0.top.equalTo(contentSection.snp.top)
      $0.leading.equalToSuperview().inset(59)
      $0.trailing.equalToSuperview().inset(20)
      $0.height.greaterThanOrEqualTo(1)
      $0.bottom.equalToSuperview()
    }
  }
}

extension FeedCommentCell {
  private func setDate(comment: FeedDetailComment) {
    contentSection.updateData(isOwner: comment.isOwner, isReply: comment.isReply, commentId: comment.commentId, profileImage: comment.profileImage, nickname: comment.nickname, content: comment.content, createdAt: comment.createdAt, isLike: comment.isLike, likeCount: comment.likeCount)
    
    if comment.childCount > 0 {
      
      
    }
  }
  
  func updateReplyStackView() {
    
  }
}
