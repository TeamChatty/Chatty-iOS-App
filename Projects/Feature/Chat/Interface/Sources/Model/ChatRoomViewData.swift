//
//  ChatRoomViewData.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 2/23/24.
//

import Foundation
import DomainUserInterface

public struct ChatRoomViewData: Hashable {
  public let roomId: Int
  public let recieverProfile: ProfileData
  public var lastMessage: ChatMessageViewData?
  public var chatRoomActiveStatus: ChatRoomType
  public var createdTime: Date?
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(roomId)
    hasher.combine(lastMessage)
    hasher.combine(chatRoomActiveStatus)
  }
  
  public static func ==(lhs: ChatRoomViewData, rhs: ChatRoomViewData) -> Bool {
    return lhs.roomId == rhs.roomId
    && lhs.lastMessage == rhs.lastMessage
    && lhs.chatRoomActiveStatus == rhs.chatRoomActiveStatus
  }
  
  public init(roomId: Int, recieverProfile: ProfileData, lastMessage: ChatMessageViewData? = nil, chatRoomActiveStatus: ChatRoomType, createdTime: Date?) {
    self.roomId = roomId
    self.recieverProfile = recieverProfile
    self.lastMessage = lastMessage
    self.chatRoomActiveStatus = chatRoomActiveStatus
    self.createdTime = createdTime
  }
}

public enum ChatRoomType: Hashable {
  case temporary(creationTime: Date?)
  case unlimited
}
