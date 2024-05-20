//
//  NotificationReceiveCheck.swift
//  DomainUserInterface
//
//  Created by 윤지호 on 4/29/24.
//

import Foundation

public struct NotificationReceiveCheck {
  public let marketingNotification: Bool
  public let chattingNotification: Bool
  public let feedNotification: Bool
  
  public init(marketingNotification: Bool, chattingNotification: Bool, feedNotification: Bool) {
    self.marketingNotification = marketingNotification
    self.chattingNotification = chattingNotification
    self.feedNotification = feedNotification
  }
}
