//
//  FeedMyCommentCellView.swift
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

final class FeedMyCommentCellView: BaseView, Touchable {
  
  // MARK: - View Property
  private let profileImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.layer.cornerRadius = 36 / 2
    $0.clipsToBounds = true
  }
  private let nicknameLabel: UILabel = UILabel().then {
    $0.font = SystemFont.body02.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  private let myCommentLabel: BasePaddingLabel = BasePaddingLabel(padding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)).then {
    $0.text = "내 댓글"
   
    $0.font = SystemFont.custom(type: .Light, size: 10).font
    $0.textColor = SystemColor.basicWhite.uiColor
    
    $0.backgroundColor = SystemColor.primaryNormal.uiColor
    $0.layer.cornerRadius = 20 / 2
    $0.clipsToBounds = true
  }
  private let contentLabel: VerticalAlignLabel = VerticalAlignLabel().then {
    $0.font = SystemFont.body03.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  
  private let createdAtLabel: UILabel = UILabel().then {
    $0.font = SystemFont.caption03.font
    $0.textColor = SystemColor.gray500.uiColor
  }
  private let likeButton: ChangeableImageButton = ChangeableImageButton().then {
    typealias Config = ChangeableImageButton.Configuration
    let deselectedState = Config(image: Images.love.image, isEnabled: true)
    let selectedState = Config(image: Images.loveSolid.image, isEnabled: true)
    $0.setState(deselectedState, for: .disabled)
    $0.setState(selectedState, for: .enabled)
  }
  private let replyButton: TextButton = TextButton().then {
    $0.font = SystemFont.caption03.font
    $0.textColor = SystemColor.gray500.uiColor
  }
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Stored Property
  private var postId: Int?
  private var commentId: Int?
  
  private var isLike: Bool? {
    didSet {
      guard let isLike else { return }
      likeButton.currentState = isLike ? .enabled: .disabled
    }
  }
  private var likeCount: Int? {
    didSet {
      guard let likeCount,
            likeCount > 0 else {
        replyButton.title = " ・ 답글달기"
        return
      }
      replyButton.title = " \(likeCount) ・ 답글달기"
    }
  }
  
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  enum TouchEventType {
    case showPostForReply(postId: Int)
    case like(commentId: Int, changedState: Bool)
  }

  // MARK: - UIConfigurable
  override func configureUI() {
    setupView()
  }
  
  // MARK: - UIBindable
  override func bind() {
    likeButton.touchEventRelay
      .do(onNext: { [weak self] _ in
        guard let self,
              let likeCount = self.likeCount else { return }
        let nowState = self.likeButton.currentState

        if nowState == .enabled {
          if likeCount > 0 {
            self.likeCount = likeCount - 1
          }
        } else {
          self.likeCount = likeCount + 1
        }
        
        self.likeButton.currentState = nowState == .enabled ? .disabled : .enabled
      })
      .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
      .withUnretained(self)
      .map { owner, _ in
        let changedState: Bool = owner.likeButton.currentState == .enabled ? true : false
        return TouchEventType.like(
          commentId: owner.commentId ?? 0, changedState: changedState
        )
      }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    replyButton.touchEventRelay
      .withUnretained(self)
      .map { owner, _ in
        return TouchEventType.showPostForReply(postId: owner.postId ?? 0)
      }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension FeedMyCommentCellView {
  private func setupView() {
    addSubview(profileImageView)
    addSubview(nicknameLabel)
    addSubview(myCommentLabel)
    addSubview(contentLabel)
    
    addSubview(createdAtLabel)
    addSubview(likeButton)
    addSubview(replyButton)
    
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(12)
      $0.leading.equalToSuperview()
      $0.width.height.equalTo(36)
    }
  
    nicknameLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.top).offset(-3)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
      $0.height.equalTo(20)
    }
    
    myCommentLabel.snp.makeConstraints {
      $0.centerY.equalTo(nicknameLabel.snp.centerY)
      $0.leading.equalTo(nicknameLabel.snp.trailing).offset(6)
      $0.height.equalTo(20)
    }
    
    contentLabel.snp.makeConstraints {
      $0.top.equalTo(nicknameLabel.snp.bottom).offset(4)
      $0.leading.equalTo(nicknameLabel.snp.leading)
      $0.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(20)
    }
    
    createdAtLabel.snp.makeConstraints {
      $0.top.equalTo(contentLabel.snp.bottom).offset(8)
      $0.height.equalTo(18)
      $0.leading.equalTo(nicknameLabel.snp.leading)
      $0.bottom.equalToSuperview().inset(8)
    }
    likeButton.snp.makeConstraints {
      $0.centerY.equalTo(createdAtLabel.snp.centerY)
      $0.leading.equalTo(createdAtLabel.snp.trailing)
      $0.width.height.equalTo(18)
    }
    replyButton.snp.makeConstraints {
      $0.centerY.equalTo(createdAtLabel.snp.centerY)
      $0.leading.equalTo(likeButton.snp.trailing)
      $0.height.equalTo(18)
    }
  }
}

extension FeedMyCommentCellView {
  func updateData(postId: Int, commentId: Int, profileImage: String?, nickname: String, content: String, createdAt: String, isLike: Bool, likeCount: Int) {
    self.postId = postId
    self.commentId = commentId
    
    profileImageView.setProfileImageKF(urlString: profileImage, gender: .male, scale: .s36)
    nicknameLabel.text = nickname
    contentLabel.text = content
    
    createdAtLabel.text = "\(createdAt.toTimeDifference()) ・ "
    
    self.isLike = isLike
    self.likeCount = likeCount
  }
}

