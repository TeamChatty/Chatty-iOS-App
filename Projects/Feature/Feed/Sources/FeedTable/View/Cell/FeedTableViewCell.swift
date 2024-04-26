//
//  FeedTableViewCell.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/15/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

import SharedDesignSystem
import DomainCommunityInterface

final class FeedTableViewCell: UITableViewCell, Touchable {
  static let cellId: String = "FeedTableViewCell"
  
  // MARK: - View Property
  // HeaderSection
  private let headerSectionView: HeaderSecionView = HeaderSecionView().then {
    $0.backgroundColor = SystemColor.basicWhite.uiColor
  }
  
  // ContentSection
  private let contentSectionView: ContentSectionView = ContentSectionView().then {
    $0.backgroundColor = SystemColor.basicWhite.uiColor

  }
  private let divider: UIView = UIView().then {
    $0.backgroundColor = SystemColor.gray100.uiColor
  }
  
  // BottomSection
  private let bottomSectionView: BottomButtonsSectionView = BottomButtonsSectionView().then {
    $0.backgroundColor = SystemColor.basicWhite.uiColor
  }
  private let insetView = UIView().then {
    $0.backgroundColor = SystemColor.gray100.uiColor
  }
  
  // MARK: - Stored Property
  private var feed: Feed? {
    didSet {
      if let feed {
        headerSectionView.setData(feedData: feed)
        contentSectionView.setData(feedData: feed)
        bottomSectionView.setData(feedData: feed)
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
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
    reuseCell()
  }
  
  // MARK: - UIConfigurable
  private func configureUI() {
    setView()
  }
  
  // MARK: - UIBindable
  private func bind() {
    headerSectionView.touchEventRelay
      .withUnretained(self)
      .map { owner, event in
        switch event {
        case .report:
          return TouchEventType.report(userId: owner.feed?.userId ?? 0)
        }
      }
      .bind(to: touchEventRelay)
      .disposed(by: cellDisposeBag)
    
    contentSectionView.touchEventRelay
      .withUnretained(self)
      .map { owner, event in
        switch event {
        case .moreDetail:
          return TouchEventType.showDetail(postId: owner.feed?.postId ?? 0)
        }
      }
      .bind(to: touchEventRelay)
      .disposed(by: cellDisposeBag)
    
    bottomSectionView.touchEventRelay
      .withUnretained(self)
      .map { owner, event in
        switch event {
        case .comment:
          return TouchEventType.showDetail(postId: owner.feed?.postId ?? 0)
        case .bookmark:
          return TouchEventType.bookmark(postId: owner.feed?.postId ?? 0)
        case .favorite:
          return TouchEventType.favorite(postId: owner.feed?.postId ?? 0)
        }
      }
      .bind(to: touchEventRelay)
      .disposed(by: cellDisposeBag)
  }
}

extension FeedTableViewCell {
  enum TouchEventType {
    case showDetail(postId: Int)
    case report(userId: Int)
    case bookmark(postId: Int)
    case favorite(postId: Int)
  }
}

/// update Stored Property
extension FeedTableViewCell {
  func setData(feedData: Feed) {
    feed = feedData
  }
  
  /// 북마크 버튼 update
  func updateBookmarkButton(marked: Bool) {
    bottomSectionView.updateBookMarkButton(marked: marked)
  }
  
  /// 좋아요 버튼 update
  func updateHeartButton(marked: Bool, heartCount: Int) {
    bottomSectionView.updateHeartButton(marked: marked, heartCount: heartCount)
  }
  
  /// 코멘트 버튼 라벨 update
  func updateCommentButton(commentCount: Int) {
    bottomSectionView.updateCommentCountLabel(commentCount: commentCount)
  }
}

/// prepareForReuse Method
extension FeedTableViewCell {
  private func reuseCell() {
    resuseHeaderSection()
    resuseContentSection()
    resuseBottomSection()
  }
  private func resuseHeaderSection() {
    
  }
  
  private func resuseContentSection() {
    contentSectionView.reuseView()
  }
  
  private func resuseBottomSection() {
    
  }
}

/// SetView
extension FeedTableViewCell {
  private func setView() {
    contentView.addSubview(headerSectionView)
    contentView.addSubview(contentSectionView)
    contentView.addSubview(divider)
    contentView.addSubview(bottomSectionView)
    contentView.addSubview(insetView)

    headerSectionView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(16)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(36)
    }
    contentSectionView.snp.makeConstraints {
      $0.top.equalTo(headerSectionView.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.greaterThanOrEqualTo(40)
    }
    divider.snp.makeConstraints {
      $0.top.equalTo(contentSectionView.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(1)
    }
    bottomSectionView.snp.makeConstraints {
      $0.top.equalTo(divider.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.greaterThanOrEqualTo(24)
    }
    insetView.snp.makeConstraints {
      $0.top.equalTo(bottomSectionView.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(8)
      $0.bottom.equalToSuperview()
    }
  }
}

/// update View Layout
extension FeedTableViewCell {
  private func updateContentSectionView() {
    let imagesButtonHeight = (CGRect.appFrame.width - 40) / 2
    contentSectionView.snp.remakeConstraints {
      $0.top.equalTo(headerSectionView.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.greaterThanOrEqualTo(80 + imagesButtonHeight)
    }
  }
}
