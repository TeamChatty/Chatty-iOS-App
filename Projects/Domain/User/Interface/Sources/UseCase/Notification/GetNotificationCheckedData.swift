//
//  GetNotificationCheckedData.swift
//  DomainUserInterface
//
//  Created by 윤지호 on 4/29/24.
//

import Foundation
import RxSwift

public protocol GetNotificationCheckedData {
  func execute() -> Observable<NotificationReceiveCheck>
}
