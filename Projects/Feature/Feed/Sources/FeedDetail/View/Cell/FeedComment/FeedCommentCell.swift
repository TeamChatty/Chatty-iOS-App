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
  private let contentSection: UIView = UIView().then {
    $0.backgroundColor = .brown
  }
  private let replySection: UIView = UIView().then {
    $0.backgroundColor = .blue
  }
  
  // MARK: - Stored Property
  private var feed: Feed? {
    didSet {
      if let feed {
        
      }
    }
  }
  
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
    case report(commentId: Int)
    case favorite(postId: Int, nowState: Bool)
    case reply(commentId: Int)
  }
}

/// SetView
extension FeedCommentCell {
  private func setView() {
    contentView.addSubview(contentSection)
    contentView.addSubview(replySection)
    
    contentSection.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.height.equalTo(50)
    }
    
    replySection.snp.makeConstraints {
      $0.top.equalTo(contentSection.snp.top)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(8)
      $0.bottom.equalToSuperview()
    }
  }
}

