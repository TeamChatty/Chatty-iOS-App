//
//  BottomButtonsSectionView.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/19/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import SharedDesignSystem
import DomainCommunityInterface

final class BottomButtonsSectionView: BaseView, Touchable {
  // MARK: - View Property
  private let heartAndCommentButtonView: ContentsImageButton = ContentsImageButton()
  private let bookmarkButton: ChangeableImageButton = ChangeableImageButton().then {
    typealias Config = ChangeableImageButton.Configuration
    let deselectedState = Config(image: Images.saved.image, isEnabled: true)
    let selectedState = Config(image: Images.savedSolid.image, isEnabled: true)
    $0.setState(deselectedState, for: .disabled)
    $0.setState(selectedState, for: .enabled)
 
    $0.currentState = .disabled
  }
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  
  // MARK: - UIConfigurable
  override func configureUI() {
    setupBottomSection()
  }
  
  // MARK: - UIBindable
  override func bind() {
    heartAndCommentButtonView.touchEventRelay
      .map { event in
        switch event {
        case .heart(let changedState):
          return TouchEventType.favorite(changedState: changedState)
        case .comment:
          return TouchEventType.comment
        }
      }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    bookmarkButton.touchEventRelay
      .do(onNext: { [weak self] _ in
        self?.bookmarkButton.currentState = self?.bookmarkButton.currentState == .enabled ? .disabled : .enabled
      })
      .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
      .withUnretained(self)
      .map { owner, _ in
        let changedState: Bool = owner.bookmarkButton.currentState == .enabled ? true : false
        return TouchEventType.bookmark(changedState: changedState)
      }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension BottomButtonsSectionView {
  enum TouchEventType {
    case favorite(changedState: Bool)
    case comment
    case bookmark(changedState: Bool)
  }
}

extension BottomButtonsSectionView {
  private func setupBottomSection() {
    addSubview(bookmarkButton)
    addSubview(heartAndCommentButtonView)
    
    bookmarkButton.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.width.height.equalTo(24)
      $0.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
    
    heartAndCommentButtonView.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.centerY.equalTo(bookmarkButton)
      $0.height.equalTo(24)
    }
  }
}

extension BottomButtonsSectionView {
  func setData(feedData: Feed) {
    heartAndCommentButtonView.updateHeartButton(marked: feedData.like, heartCount: feedData.likeCount)
    heartAndCommentButtonView.updateCommentCountLabel(commentCount: feedData.commentCount)

    updateCommentCountLabel(commentCount: feedData.commentCount)
    
    bookmarkButton.currentState = feedData.bookmark ? .enabled : .disabled
  }
  
  func updateCommentCountLabel(commentCount: Int) {
    heartAndCommentButtonView.updateCommentCountLabel(commentCount: commentCount)
  }
}
