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
    let deselectedState = Config(image: Images.saved.image, tintColor: SystemColor.basicBlack.uiColor, isEnabled: true)
    let selectedState = Config(image: Images.savedSolid.image, tintColor: SystemColor.basicBlack.uiColor, isEnabled: true)
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
        case .heart:
          return TouchEventType.favorite
        case .comment:
          return TouchEventType.comment
        }
      }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    bookmarkButton.touchEventRelay
      .map { TouchEventType.bookmark }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension BottomButtonsSectionView {
  enum TouchEventType {
    case favorite
    case comment
    case bookmark
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
    
    bookmarkButton.touchEventRelay
      .bind(with: self) { owner, _ in
        let nowState = owner.bookmarkButton.currentState
        owner.bookmarkButton.currentState = nowState == .enabled ? .disabled : .enabled
      }
      .disposed(by: disposeBag)
    
    heartAndCommentButtonView.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.centerY.equalTo(bookmarkButton)
      $0.height.equalTo(24)
    }
  }
}

extension BottomButtonsSectionView {
  func setData(feedData: Feed) {
    if feedData.postId == 2 {
      heartAndCommentButtonView.updateHeartButton(marked: true, heartCount: 10)
      updateCommentCountLabel(commentCount: 10)
    }
//    heartAndCommentButtonView.updateHeartButton(marked: marked, heartCount: heartCount)
//    heartAndCommentButtonView.updateCommentCountLabel(commentCount: commentCount)
//    bookmarkButton.currentState = marked ? .enabled : .disabled
  }
  
  func updateHeartButton(marked: Bool, heartCount: Int) {
    heartAndCommentButtonView.updateHeartButton(marked: marked, heartCount: heartCount)
  }
  
  func updateCommentCountLabel(commentCount: Int) {
    heartAndCommentButtonView.updateCommentCountLabel(commentCount: commentCount)
  }
  
  func updateBookMarkButton(marked: Bool) {
    bookmarkButton.currentState = marked ? .enabled : .disabled
  }
}
