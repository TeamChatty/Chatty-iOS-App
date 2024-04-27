//
//  ChatRoomListResponseDTO.swift
//  DataNetworkInterface
//
//  Created by HUNHIE LEE on 2/26/24.
//

import Foundation
import DomainChatInterface

public struct ChatRoomListResponseDTO: CommonResponseDTO {
  public var code: Int
  public var status: String
  public var message: String
  public var data: [ChatListItem]

  public func toDomain() -> [ChatRoom] {
    return data.map {
      ChatRoom(
        roomId: $0.roomId,
        partnerId: $0.senderId,
        partnerNickname: $0.senderNickname,
        partnerImageURL: $0.senderImageURL,
        lastMessage: .init(
          content: .text($0.lastMessage ?? ""),
          senderId: $0.senderId,
          sendTime: $0.lastMessageCreatedTime.toDateFromISO8601(),
          roomId: $0.roomId
        ),
        unreadMessageCount: $0.unreadMessageCount,
        blueCheck: $0.blueCheck,
        chatRoomCreatedTime: $0.chatRoomCreatedTime.toDateFromISO8601(),
        extend: $0.extend
      )
    }
  }
}
