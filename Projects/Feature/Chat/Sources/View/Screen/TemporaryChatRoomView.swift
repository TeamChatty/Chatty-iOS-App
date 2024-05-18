//
//  TemporaryChatRoomView.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 17.04.2024.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit
import SharedDesignSystem
import DomainChatInterface

public final class TemporaryChatRoomView: BaseView, Touchable {
  public let chatRoomHeaderBar: TemporaryChatRoomHeaderBar = TemporaryChatRoomHeaderBar()
  private let chatRoomAnnounceView: ChatRoomAnnounceView = ChatRoomAnnounceView()
  public lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
    $0.contentInset = .init(top: 52, left: 0, bottom: 0, right: 0)
    $0.scrollIndicatorInsets = .init(top: 52, left: 0, bottom: 0, right: 0)
    $0.backgroundColor = SystemColor.gray100.uiColor
  }
  private lazy var chatInputBar: ChatInputBar = ChatInputBar().then {
    $0.textView.delegate = self
  }
  
  public let inputEventRelay: PublishRelay<MessageContentType> = .init()
  public let touchEventRelay: PublishRelay<TemporaryChatRoomHeaderBar.TouchEventType> = .init()
  private let disposeBag = DisposeBag()
  
  public override func configureUI() {
    super.configureUI()
    setChatRoomHeaderBar()
    setChatInputBar()
    setCollectionView()
    setChatRoomAnnounceView()
  }
  
  public override func bind() {
    super.bind()
    chatRoomHeaderBar.touchEventRelay
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
    
    chatInputBar.inputEventRelay
      .bind(to: inputEventRelay)
      .disposed(by: disposeBag)
  }
  
  public func updateTimeLabel(_ time: String) {
    chatRoomHeaderBar.timerLabel.text = time
  }
  
  private func setChatRoomHeaderBar() {
    addSubview(chatRoomHeaderBar)
    chatRoomHeaderBar.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(80)
    }
  }
  
  private func setChatRoomAnnounceView() {
    addSubview(chatRoomAnnounceView)
    chatRoomAnnounceView.snp.makeConstraints {
      $0.top.equalTo(chatRoomHeaderBar.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(44)
    }
  }
  
  private func setCollectionView() {
    addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.top.equalTo(chatRoomHeaderBar.snp.bottom)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalTo(chatInputBar.snp.top)
    }
  }
  
  private func setChatInputBar() {
    addSubview(chatInputBar)
    chatInputBar.snp.makeConstraints {
      $0.bottom.equalTo(keyboardLayoutGuide.snp.top)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(60)
    }
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
}

extension TemporaryChatRoomView: UITextViewDelegate {
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
}
