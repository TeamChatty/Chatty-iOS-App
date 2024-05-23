//
//  DefaultGetSomeoneProfileUseCase.swift
//  DomainUser
//
//  Created by 윤지호 on 5/20/24.
//

import Foundation
import RxSwift
import DomainUserInterface

/// 같은 UseCase가 있어 임시로 추가했습니다.
public final class DefaultGetSomeoneProfileUseCaseTemp: GetSomeoneProfileUseCase {
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
