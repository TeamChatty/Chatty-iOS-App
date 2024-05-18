//
//  DefaultGetSomeoneProfileUseCase.swift
//  DomainUser
//
//  Created by HUNHIE LEE on 30.04.2024.
//

import Foundation
import RxSwift
import DomainUserInterface

public final class DefaultGetSomeoneProfileUseCase {
  private let userAPIRepository: UserAPIRepositoryProtocol
  
  public init(userAPIRepository: UserAPIRepositoryProtocol) {
    self.userAPIRepository = userAPIRepository
  }
  
  public func execute(userId: Int) -> Single<SomeoneProfile> {
    return userAPIRepository.someoneProfile(userId: userId)
  }
}
