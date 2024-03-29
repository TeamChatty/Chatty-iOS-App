//
//  GetUserDataUseCase.swift
//  DomainUserInterface
//
//  Created by HUNHIE LEE on 2/3/24.
//

import Foundation
import RxSwift

public protocol GetUserDataUseCase {
  func executeSingle() -> Single<UserProfile>
  func execute() -> UserProfile
}
