//
//  GetUserProfileUseCase.swift
//  DomainUserInterface
//
//  Created by HUNHIE LEE on 2/3/24.
//

import Foundation
import RxSwift
import DomainCommon

public protocol GetUserProfileUseCase {
  func executeSingle() -> Single<UserProfile>
  func execute() -> UserProfile
}
