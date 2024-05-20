//
//  DefaultSaveNotificationBoolean.swift
//  DomainUser
//
//  Created by 윤지호 on 4/29/24.
//

import Foundation
import DomainUserInterface
import RxSwift

public final class DefaultSaveNotificationBoolean: SaveNotificationBoolean {
 
  private let userAPIRepository: any UserAPIRepositoryProtocol

  public init(userAPIRepository: any UserAPIRepositoryProtocol) {
    self.userAPIRepository = userAPIRepository
  }
  
  public func execute(type: NotificationType, agree: Bool) -> Observable<Void> {
    switch type {
    case .chatting:
      self.userAPIRepository.saveNotiChattingReceive(agree: agree)
    case .feed:
      self.userAPIRepository.saveNotiFeedReceive(agree: agree)
    case .marketing:
      self.userAPIRepository.saveNotiMarketingReceive(agree: agree)
    }
    
  }
}
