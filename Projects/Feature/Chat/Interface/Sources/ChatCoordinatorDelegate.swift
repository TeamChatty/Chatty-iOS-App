//
//  ChatCoordinatorDelegate.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 17.04.2024.
//

import Foundation
import SharedDesignSystem
import DomainChatInterface

public protocol ChatCoordinatorDelegate: AnyObject {
  func pushToChatRoom(roomViewData: ChatRoomViewData)
  func pushToTemporaryChatRoom(roomData: ChatRoom)
  func pushToChatRoomFromFeed(roomData: ChatRoom)
}
