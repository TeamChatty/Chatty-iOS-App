//
//  ChatMessagesResponseDTO.swift
//  DataNetworkInterface
//
//  Created by HUNHIE LEE on 2/14/24.
//

import Foundation
import DomainChatInterface
import SharedUtil

public struct ChatMessagesResponseDTO: CommonResponseDTO {
  public let code: Int
  public let status: String
  public let message: String
  public let data: [ChatMessageResponse]
  
  public func toDomain() -> [ChatMessage] {
    self.data.map {
      ChatMessage(content: .text($0.content), senderId: $0.senderID, sendTime: $0.sendTime.toDateFromISO8601(), roomId: $0.roomID)
    }
  }
}

public struct ChatMessageResponse: Decodable {
  let chatMessageID, roomID, yourID: Int
  let yourNickname: String
  let yourImageURL: String?
  let yourBlueCheck: Bool
  let senderID: Int
  let content, sendTime: String
  let yourIsRead: Bool

  enum CodingKeys: String, CodingKey {
      case chatMessageID = "chatMessageId"
      case roomID = "roomId"
      case yourID = "yourId"
      case yourNickname
      case yourImageURL = "yourImageUrl"
      case yourBlueCheck
      case senderID = "senderId"
      case content, sendTime, yourIsRead
  }
}
