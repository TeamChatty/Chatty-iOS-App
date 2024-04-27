//
//  ChatMessageViewData.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 2/14/24.
//

import Foundation
import DomainChatInterface

public struct ChatMessageViewData: Hashable {
  public let roomId: Int
  public let content: MessageContentType
  public let senderType: ChatParticipantType
  public let sendTime: Date?
  public var accessoryConfig: ChatMessageViewConfiguration = .init(timeLabelVisible: true, nicknameAndProfileVisible: true)
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(roomId)
    hasher.combine(content)
    hasher.combine(senderType)
    hasher.combine(sendTime)
    hasher.combine(accessoryConfig)
  }
  
  public static func == (lhs: ChatMessageViewData, rhs: ChatMessageViewData) -> Bool {
    return lhs.roomId == rhs.roomId
    && lhs.content == rhs.content
    && lhs.senderType == rhs.senderType
    && lhs.sendTime == rhs.sendTime
    && lhs.accessoryConfig == rhs.accessoryConfig
  }
  
  public init(roomId: Int, content: MessageContentType, senderType: ChatParticipantType, sendTime: Date?) {
    self.roomId = roomId
    self.content = content
    self.senderType = senderType
    self.sendTime = sendTime
  }
}

public struct ChatMessageViewConfiguration: Hashable {
  public var timeLabelVisible: Bool
  public var nicknameAndProfileVisible: Bool
  
  public init(timeLabelVisible: Bool, nicknameAndProfileVisible: Bool) {
    self.timeLabelVisible = timeLabelVisible
    self.nicknameAndProfileVisible = nicknameAndProfileVisible
  }
}
