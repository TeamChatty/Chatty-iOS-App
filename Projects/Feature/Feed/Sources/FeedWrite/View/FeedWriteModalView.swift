//
//  FeedWriteModalView.swift
//  FeatureFeedInterface
//
//  Created by 윤지호 on 4/19/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

import SharedDesignSystem

final class FeedWriteModalView: BaseView, Touchable {
  // MARK: - View Property
  private let titleLabel: UILabel = UILabel().then {
    $0.text = "글쓰기"
    $0.font = SystemFont.title02.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  private let cancelButton: CancelButton = CancelButton()
  
  private let imageScrollView: AddImageScrollView = AddImageScrollView()
  private let contentTextView: PaddingTextView = PaddingTextView(maxTextLength: 500, paddingInset: 0).then {
    $0.textView.font = SystemFont.body01.font
    $0.textView.textColor = SystemColor.basicBlack.uiColor
    
    $0.placeholderText = "대화하고 싶은 주제, 나누고 싶은 이야기 등을 공유하세요.\n등록한 글은 수정과 삭제가 어려우니 참고해주세요."
    $0.isPlaceholderEnabled = true
    
    $0.backgroundColor = SystemColor.basicWhite.uiColor
    $0.layer.cornerRadius = 8
  }
  private let saveButton: FillButton = FillButton().then {
    $0.title = "작성하기"
    typealias Configuration = FillButton.Configuration
    let enabledConfig = Configuration(
      backgroundColor: SystemColor.primaryNormal.uiColor,
      isEnabled: true
    )
    let disabledConfig = Configuration(
      backgroundColor: SystemColor.gray300.uiColor,
      isEnabled: false
    )
    $0.setState(enabledConfig, for: .enabled)
    $0.setState(disabledConfig, for: .disabled)

    $0.currentState = .enabled
    $0.cornerRadius = 8
  }
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  // MARK: - Touchable Property
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  
  // MARK: - UIConfigurable
  override func configureUI() {
    setupHeaderViews()
    setupImageScrollView()
    setupContentTextView()
    setupSaveButton()
  }
  
  // MARK: - UIBindable
  override func bind() {
    cancelButton.touchEventRelay
      .map { TouchEventType.cancel }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    imageScrollView.touchEventRelay
      .map { event in
        switch event {
        case .addImage:
          return TouchEventType.addImage
        case .removeImage(let identifier):
          return TouchEventType.removeImage(identifier: identifier)
        }
      }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    saveButton.touchEventRelay
      .map { TouchEventType.save }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
}

extension FeedWriteModalView {
  enum TouchEventType {
    case cancel
    case inputText(String)
    case addImage
    case removeImage(identifier: String)
    case save
  }
}

extension FeedWriteModalView {
  private func setupHeaderViews() {
    addSubview(titleLabel)
    addSubview(cancelButton)
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(60)
      $0.leading.equalToSuperview().inset(20)
      $0.height.equalTo(22)
    }
    
    cancelButton.snp.makeConstraints {
      $0.centerY.equalTo(titleLabel)
      $0.trailing.equalToSuperview().inset(20)
    }
  }
  private func setupImageScrollView() {
    addSubview(imageScrollView)
    imageScrollView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(12)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(90)
    }
  }
  
  private func setupContentTextView() {
    addSubview(contentTextView)
    contentTextView.snp.makeConstraints {
      $0.top.equalTo(imageScrollView.snp.bottom).offset(20)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(300)
    }
  }
  
  private func setupSaveButton() {
    addSubview(saveButton)
    saveButton.snp.makeConstraints {
      $0.height.equalTo(52)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalTo(self.keyboardLayoutGuide.snp.top).offset(-16)
    }
  }
}

extension FeedWriteModalView {
  func updateSaveButtonEnabled(isEnabled: Bool) {
    saveButton.currentState = isEnabled ? .enabled : .disabled
  }
  
  func removeButton() {
    saveButton.removeFromSuperview()
  }
  
  func updateAddedImages(images: [AddedImage]) {
    imageScrollView.updateAddedImages(images: images)
  }
  
  func updateAddedImagesCount(count: Int) {
    imageScrollView.updateAddedImagesCount(count: count)
  }
  
  func updateRemovedImage(imageId: String) {
    imageScrollView.updateRemovedImage(imageId: imageId)
  }
}
