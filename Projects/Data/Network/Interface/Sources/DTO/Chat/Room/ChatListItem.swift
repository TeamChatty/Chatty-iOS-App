//
//  ChatListItem.swift
//  DataNetworkInterface
//
//  Created by HUNHIE LEE on 2/26/24.
//

import Foundation

public struct ChatListItem: Decodable {
  let roomId, senderId: Int
  let senderNickname: String
  let senderImageURL: String?
  let blueCheck: Bool
  let lastMessage: String?
  let lastMessageCreatedTime: String
  let chatRoomCreatedTime: String
  let unreadMessageCount: Int
  let extend: Bool
  
  enum CodingKeys: String, CodingKey {
    case roomId
    case senderId
    case senderNickname
    case senderImageURL = "senderImageUrl"
    case blueCheck, chatRoomCreatedTime, lastMessage, lastMessageCreatedTime, unreadMessageCount
    case extend
  }
}
