//
//  DefaultGetSomeoneProfileUseCase.swift
//  DomainUser
//
//  Created by 윤지호 on 5/20/24.
//

import Foundation
import RxSwift
import DomainUserInterface

public final class DefaultGetSomeoneProfileUseCase: GetSomeoneProfileUseCase {
  private let userAPIRepository: any UserAPIRepositoryProtocol
  
  public init(userAPIRepository: any UserAPIRepositoryProtocol) {
    self.userAPIRepository = userAPIRepository
  }
  
  public func execute(userId: Int) -> Single<SomeoneProfile> {
    return userAPIRepository.someoneProfile(userId: userId)
      .observe(on: MainScheduler.instance)
      .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
  }
}
