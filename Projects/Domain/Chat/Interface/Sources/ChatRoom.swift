//
//  ChatRoom.swift
//  DomainChat
//
//  Created by HUNHIE LEE on 2/26/24.
//

import Foundation

public struct ChatRoom {
  public let roomId: Int
  public let partnerId: Int
  public let partnerNickname: String
  public let partnerImageURL: String?
  public let lastMessage: ChatMessage?
  public let unreadMessageCount: Int?
  public let blueCheck: Bool
  public let chatRoomCreatedTime: Date?
  public let extend: Bool

  public init(roomId: Int, partnerId: Int, partnerNickname: String, partnerImageURL: String?, lastMessage: ChatMessage?, unreadMessageCount: Int?, blueCheck: Bool, chatRoomCreatedTime: Date?, extend: Bool) {
    self.roomId = roomId
    self.partnerId = partnerId
    self.partnerNickname = partnerNickname
    self.partnerImageURL = partnerImageURL
    self.lastMessage = lastMessage
    self.unreadMessageCount = unreadMessageCount
    self.blueCheck = blueCheck
    self.chatRoomCreatedTime = chatRoomCreatedTime
    self.extend = extend
  }
}
