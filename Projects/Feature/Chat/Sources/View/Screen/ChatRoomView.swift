//
//  ChatRoomView.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 2/10/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import SharedDesignSystem
import DomainChatInterface
import FeatureChatInterface

public final class ChatRoomView: BaseView, InputReceivable, Touchable {
  public lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
    $0.contentInset = .init(top: 52, left: 0, bottom: 0, right: 0)
    $0.scrollIndicatorInsets = .init(top: 52, left: 0, bottom: 0, right: 0)
  }
  
  private lazy var chatInputBar: ChatInputBar = ChatInputBar().then {
    $0.textView.delegate = self
  }
  
  public var chatRoomType: ChatRoomType? {
    didSet {
      guard let chatRoomType else { return }
      switch chatRoomType {
      case .temporary(creationTime: let date):
        guard let date else { return }
        chatInputBar.textView.isUserInteractionEnabled = date.isDateMoreThanTenMinutesAhead()
        print("터치 비허용")
      case .unlimited:
        print("터치 허용")
        chatInputBar.textView.isUserInteractionEnabled = true
      }
    }
  }
  public var inputEventRelay: PublishRelay<MessageContentType> = .init()
  public var touchEventRelay: PublishRelay<TouchEventType> = .init()
  
  private let disposeBag = DisposeBag()
  
  public override func configureUI() {
    addSubview(collectionView)
    addSubview(chatInputBar)
    
    chatInputBar.snp.makeConstraints {
      $0.bottom.equalTo(keyboardLayoutGuide.snp.top)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(60)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.bottom.equalTo(chatInputBar.snp.top)
    }
  }
  
  public override func bind() {
    collectionView.rx.tapGesture()
      .subscribe(with: self) { owner, gesture in
        owner.endEditing(true)
      }
      .disposed(by: disposeBag)
    
    chatInputBar.inputEventRelay
      .bind(to: inputEventRelay)
      .disposed(by: disposeBag)
    
    chatInputBar.touchEventRelay
      .filter { [weak self] _ in
        guard let self = self,
              let chatRoomType = self.chatRoomType else { return false }
        switch chatRoomType {
        case .temporary:
          print("임시 채팅방입니다")
          return true
        case .unlimited:
          print("영구 채팅방입니다")
          return false
        }
      }
      .map { _ in .chatRoomIsNotActive }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
  
  private func createLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
      let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
      
      let section = NSCollectionLayoutSection(group: group)
      
      section.boundarySupplementaryItems = [
        NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
          elementKind: UICollectionView.elementKindSectionHeader,
          alignment: .top)
      ]
      
      return section
    }
    return layout
  }
  
  public enum TouchEventType {
    case chatRoomIsNotActive
  }
}

extension ChatRoomView: UITextViewDelegate {
  public func textViewDidChange(_ textView: UITextView) {
    updateChatInputBarHeight(textView)
    updateSendButtonIsEnabeld(textView)
  }
  
  private func updateChatInputBarHeight(_ textView: UITextView) {
    let newSize = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.infinity))
    
    let minHeight = 60.0
    let maxHeight = 120.0
    let extraHeight = minHeight - 20
    let newHeight = min(max(newSize.height + extraHeight, minHeight), maxHeight)
    
    if newHeight >= maxHeight {
      chatInputBar.textView.isScrollEnabled = true
    }
    
    chatInputBar.snp.updateConstraints {
      $0.height.equalTo(newHeight)
    }
  }
  
  private func updateSendButtonIsEnabeld(_ textView: UITextView) {
    chatInputBar.updateSendButtonIsEnabled(textView.hasText)
  }

  public func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "메시지를 입력하세요"
      textView.textColor = SystemColor.gray500.uiColor
    }
  }
  
  public func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == SystemColor.gray500.uiColor {
      textView.text = nil
      textView.textColor = SystemColor.basicBlack.uiColor
    }
  }
}
