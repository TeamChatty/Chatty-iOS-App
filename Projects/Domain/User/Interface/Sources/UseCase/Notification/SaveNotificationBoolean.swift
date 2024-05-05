//
//  SaveNotificationBoolean.swift
//  DomainUserInterface
//
//  Created by 윤지호 on 4/29/24.
//

import Foundation
import RxSwift

public protocol SaveNotificationBoolean {
  func execute(type: NotificationType, agree: Bool) -> Observable<Void>
}
