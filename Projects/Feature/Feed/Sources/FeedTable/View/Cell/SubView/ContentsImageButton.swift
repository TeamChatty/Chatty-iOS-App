//
//  ContentsImageButton.swift
//  FeatureFeedInterface
//
//  Created by 윤지호 on 4/15/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

import SharedDesignSystem

final class ContentsImageButton: BaseView, Touchable {
  // MARK: - View Property
  private let heartButton: ChangeableImageButton = ChangeableImageButton().then {
    typealias Config = ChangeableImageButton.Configuration
    let deselectedState = Config(image: Images.love.image, tintColor: SystemColor.basicBlack.uiColor, isEnabled: true)
    let selectedState = Config(image: Images.loveSolid.image, tintColor: SystemColor.basicBlack.uiColor, isEnabled: true)
    $0.setState(deselectedState, for: .disabled)
    $0.setState(selectedState, for: .enabled)
 
    $0.currentState = .disabled
  }
  
  private let heartCountLabel: UILabel = UILabel().then {
    $0.font = SystemFont.body03.font
    $0.textColor = SystemColor.gray500.uiColor
  }
  
  private let commentButton: ChangeableImageButton = ChangeableImageButton().then {
    typealias Config = ChangeableImageButton.Configuration
    let commonState = Config(image: Images.comment.image, tintColor: SystemColor.basicBlack.uiColor, isEnabled: true)
    $0.setState(commonState, for: .customImage)
 
    $0.currentState = .customImage
  }
  
  private let commentCountLabel: UILabel = UILabel().then {
    $0.font = SystemFont.body03.font
    $0.textColor = SystemColor.gray500.uiColor
  }
  
  private var likeCount: Int? {
    didSet {
      guard let likeCount else { return }
      
      if likeCount == 0 {
        self.heartCountLabel.text = ""

        heartCountLabel.snp.updateConstraints {
          $0.leading.equalTo(heartButton.snp.trailing).offset(4)
          $0.width.greaterThanOrEqualTo(1)
          $0.centerY.equalToSuperview()
        }
      } else {
        self.heartCountLabel.text = "\(likeCount)"
      }
    }
  }
  
  private var commentCount: Int? {
    didSet {
      guard let commentCount else { return }
      self.commentCountLabel.text = commentCount == 0 ? "" : "\(commentCount)"
    }
  }

  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()

  // MARK: - UIConfigurable
  override func configureUI() {
    addSubview(heartButton)
    addSubview(heartCountLabel)
    addSubview(commentButton)
    addSubview(commentCountLabel)
    
    heartButton.snp.makeConstraints {
      $0.leading.verticalEdges.equalToSuperview()
      $0.width.equalTo(24)
    }
    
    heartCountLabel.snp.makeConstraints {
      $0.leading.equalTo(heartButton.snp.trailing).offset(4)
      $0.width.greaterThanOrEqualTo(1)
      $0.centerY.equalToSuperview()
    }
    
    commentButton.snp.makeConstraints {
      $0.leading.equalTo(heartCountLabel.snp.trailing).offset(20)
      $0.width.greaterThanOrEqualTo(24)
      $0.centerY.verticalEdges.equalToSuperview()
    }
    
    commentCountLabel.snp.makeConstraints {
      $0.leading.equalTo(commentButton.snp.trailing).offset(4)
      $0.width.greaterThanOrEqualTo(1)
      $0.centerY.trailing.equalToSuperview()
    }
    
  }
  // MARK: - UIBindable
  override func bind() {
    heartButton.touchEventRelay
      .do(onNext: { [weak self] _ in
        guard let self,
              let likeCount else { return }
        let nowState = self.heartButton.currentState

        self.likeCount = nowState == .enabled ? likeCount - 1 : likeCount + 1
        self.heartButton.currentState = nowState == .enabled ? .disabled : .enabled
      })
      .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
      .withUnretained(self)
      .map { owner, _ in
        let changedState: Bool = owner.heartButton.currentState == .enabled ? true : false
        return TouchEventType.heart(changedState: changedState)
      }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    commentButton.touchEventRelay
      .map { TouchEventType.comment }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension ContentsImageButton {
  enum TouchEventType {
    case heart(changedState: Bool)
    case comment
  }
}
 
extension ContentsImageButton {
  func updateHeartButton(marked: Bool, heartCount: Int) {
    heartButton.currentState = marked ? .enabled : .disabled
    likeCount = heartCount
    
  }
  
  func updateCommentCountLabel(commentCount: Int) {
    self.commentCount = commentCount
  }
}
