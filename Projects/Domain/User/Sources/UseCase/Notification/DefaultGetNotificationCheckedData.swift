//
//  DefaultGetNotificationCheckedData.swift
//  DomainUser
//
//  Created by 윤지호 on 4/29/24.
//

import Foundation
import DomainUserInterface
import RxSwift

public final class DefaultGetNotificationCheckedData: GetNotificationCheckedData {
  
  private let userAPIRepository: any UserAPIRepositoryProtocol

  public init(userAPIRepository: any UserAPIRepositoryProtocol) {
    self.userAPIRepository = userAPIRepository
  }
  
  public func execute() -> Observable<NotificationReceiveCheck> {
    return userAPIRepository.getNotiReceiveBoolean()
  }
}
