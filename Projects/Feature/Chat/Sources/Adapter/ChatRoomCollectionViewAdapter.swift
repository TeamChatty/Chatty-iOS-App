//
//  ChatRoomCollectionViewAdapter.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 2/9/24.
//

import UIKit
import SharedDesignSystem
import FeatureChatInterface

public protocol ChatCollectionViewAdapterDataSource: AnyObject {
  
}

public protocol ChatCollectionViewAdapterDelegate: AnyObject {
  
}

public final class ChatRoomCollectionViewAdapter: NSObject {
  typealias DiffableDataSource = UICollectionViewDiffableDataSource<Date, ChatMessageViewData>
  
  private var collectionView: UICollectionView
  private var diffableDataSource: DiffableDataSource?
  public weak var dataSource: ChatCollectionViewAdapterDataSource?
  public weak var delegate: ChatCollectionViewAdapterDelegate?
  
  private var dateChangePoints: [IndexPath: Date] = [:]
  private var chatRoomType: ChatRoomType?
  
  public init(collectionView: UICollectionView, chatRoomType: ChatRoomType?) {
    self.collectionView = collectionView
    self.chatRoomType = chatRoomType
    super.init()
    
    self.configureDataSource()
  }
  
  private func configureDataSource() {
    guard let chatRoomType else { return }
    let messageCellRegistration = UICollectionView.CellRegistration<ChatTextMessageCell, ChatMessageViewData> { cell, indexPath, itemIdentifier in
      cell.configureCell(with: itemIdentifier, chatRoomType: chatRoomType)
    }
    
    diffableDataSource = DiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
      let cell = collectionView.dequeueConfiguredReusableCell(using: messageCellRegistration, for: indexPath, item: itemIdentifier)
      return cell
    })
    
    collectionView.dataSource = diffableDataSource
    
    let dateHeaderRegistration = UICollectionView.SupplementaryRegistration<DateHeaderSupplementaryView>(elementKind:  UICollectionView.elementKindSectionHeader) { [weak self] supplementaryView, elementKind, indexPath in
      let sectionDate = self?.diffableDataSource?.snapshot().sectionIdentifiers[indexPath.section]
      supplementaryView.configure(with: sectionDate?.toCustomString(format: .yyyyMMddKorean) ?? "")
    }
    
    guard let diffableDataSource else { return }
    
    diffableDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
      if kind == UICollectionView.elementKindSectionHeader {
        return collectionView.dequeueConfiguredReusableSupplementary(using: dateHeaderRegistration, for: indexPath)
      }
      return nil
    }
  }
  
  public func applySnapshot(messages: [ChatMessageViewData], animatingDifferences: Bool = true) {
    var snapshot = NSDiffableDataSourceSnapshot<Date, ChatMessageViewData>()
    
    // 메시지 배열이 비어있을 경우 빈 스냅샷을 적용하고 종료
    guard !messages.isEmpty else {
      diffableDataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
      return
    }
    
    // 첫 번째 메시지의 날짜를 섹션에 추가
    if let firstMessageDate = messages.first?.sendTime?.dateOnly() {
      snapshot.appendSections([firstMessageDate])
    }
    
    // 메시지 배열을 순회하면서 날짜가 변경되는 지점을 찾아 섹션에 추가
    for index in 1..<messages.count {
      let currentDate = messages[index].sendTime?.dateOnly()
      let prevDate = messages[index - 1].sendTime?.dateOnly()
      
      // 이전 메시지와 현재 메시지의 날짜가 다른 경우에만 섹션을 추가
      if let currentDate = currentDate, let prevDate = prevDate, !Calendar.current.isDate(prevDate, inSameDayAs: currentDate) {
        snapshot.appendSections([currentDate])
      }
    }
    
    // 모든 메시지를 스냅샷에 추가
    for message in messages {
      if let messageDate = message.sendTime?.dateOnly() {
        snapshot.appendItems([message], toSection: messageDate)
      }
    }

    diffableDataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    
    collectionView.scrollToBottomSkipping(animated: animatingDifferences)
  }
  
  public func scrollToFlag(to indexPath: IndexPath) {
    collectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
  }
}
