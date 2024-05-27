//
//  CreatChatRoomResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 5/27/24.
//

import Foundation

public struct CreatChatRoomResponseDTO: CommonResponseDTO {
  public typealias Data = ResponseDTO
  public var code: Int
  public var status: String
  public var message: String
  public var data: Data

  public struct ResponseDTO: Decodable {
    public let roomId: Int
    public let senderId: Int
    public let receiverId: Int
    public let extend: Bool
  }
}
