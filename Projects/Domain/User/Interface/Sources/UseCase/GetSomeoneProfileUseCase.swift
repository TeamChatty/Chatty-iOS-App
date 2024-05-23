//
//  GetSomeoneProfileUseCase.swift
//  DomainUserInterface
//
//  Created by 윤지호 on 5/20/24.
//

import Foundation
import RxSwift

public protocol GetSomeoneProfileUseCase {
  func execute(userId: Int) -> Single<SomeoneProfile>
}
