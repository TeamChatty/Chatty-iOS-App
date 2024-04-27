//
//  ChatRoomResponseDTO.swift
//  DataNetworkInterface
//
//  Created by HUNHIE LEE on 2/13/24.
//

import Foundation
import DomainChatInterface

public struct ChatRoomResponseDTO: CommonResponseDTO {
  public var code: Int
  public var status: String
  public var message: String
  public var data: ChatRoomData
  
  public struct ChatRoomData: Decodable {
    public let roomId: Int
    public let partnerId: Int
    public let partnerNickname: String
    public let partnerImageUrl: String?
    public let chatRoomCreatedTime: String
    public let extend: Bool
    
    enum CodingKeys: String, CodingKey {
      case roomId, partnerId, partnerNickname, partnerImageUrl, chatRoomCreatedTime, extend
    }
  }
  
  public func toDomain() -> ChatRoom {
    return ChatRoom(
      roomId: data.roomId,
      partnerId: data.partnerId,
      partnerNickname: data.partnerNickname,
      partnerImageURL: data.partnerImageUrl,
      lastMessage: nil,
      unreadMessageCount: nil,
      blueCheck: false,
      chatRoomCreatedTime: data.chatRoomCreatedTime.toDateFromISO8601(),
      extend: data.extend
    )
  }
}
