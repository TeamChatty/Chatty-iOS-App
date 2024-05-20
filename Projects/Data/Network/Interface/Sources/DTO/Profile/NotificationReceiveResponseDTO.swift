//
//  NotificationReceiveResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 4/29/24.
//

import Foundation
import DomainUserInterface

public struct NotificationReceiveResponseDTO: CommonResponseDTO {
  public typealias Data = ResponseDTO
  public var code: Int
  public var status: String
  public var message: String
  public var data: Data
  
  public struct ResponseDTO: Decodable {
    public let userId: Int
    public let notificationReceiveId: Int
    public let marketingNotification: Bool
    public let chattingNotification: Bool
    public let feedNotification: Bool
  }
  
  public func toDomain() -> NotificationReceiveCheck {
    return NotificationReceiveCheck(marketingNotification: self.data.marketingNotification, chattingNotification: self.data.chattingNotification, feedNotification: self.data.feedNotification)
  }
}
