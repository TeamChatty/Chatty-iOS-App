//
//  GetInterestsUserCase.swift
//  DomainUserInterface
//
//  Created by 윤지호 on 3/7/24.
//

import Foundation
import RxSwift
import DomainCommon

public protocol GetAllInterestsUseCase {
  func execute() -> Single<Interests>
}
