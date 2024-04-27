//
//  ChatListCollectionViewAdapter.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 2/23/24.
//

import UIKit
import SharedDesignSystem
import FeatureChatInterface

protocol ChatListCollectionViewAdapterDelegate: AnyObject {
  func chatListCollectionViewAdapter(_ adapter: ChatListCollectionViewAdapter, didSelectChatRoom room: ChatRoomViewData)
}

public final class ChatListCollectionViewAdapter: NSObject {
  typealias DiffableDataSource = UICollectionViewDiffableDataSource<Int, ChatRoomViewData>
  
  private var collectionView: UICollectionView
  private var diffableDataSource: DiffableDataSource?
  weak var delegate: ChatListCollectionViewAdapterDelegate?
  
  public init(collectionView: UICollectionView) {
    self.collectionView = collectionView
    super.init()
    collectionView.delegate = self
    self.configureDataSource()
  }
  
  private func configureDataSource() {
    let chatRoomCellRegistration = UICollectionView.CellRegistration<ChatRoomListCell, ChatRoomViewData> { cell, indexPath, itemIdentifier in
      cell.configureCell(data: itemIdentifier)
    }
    
    diffableDataSource = DiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
      let cell = collectionView.dequeueConfiguredReusableCell(using: chatRoomCellRegistration, for: indexPath, item: itemIdentifier)
      return cell
    })
  }
  
  public func applySnapShot(rooms: [ChatRoomViewData], animatingDiffrences: Bool = true) {
    var snapshot = NSDiffableDataSourceSnapshot<Int, ChatRoomViewData>()
    snapshot.appendSections([0])
    snapshot.appendItems(rooms, toSection: 0)
    diffableDataSource?.apply(snapshot, animatingDifferences: animatingDiffrences)
  }
}

extension ChatListCollectionViewAdapter: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let room = diffableDataSource?.itemIdentifier(for: indexPath) else { return }
    delegate?.chatListCollectionViewAdapter(self, didSelectChatRoom: room)
  }
}
