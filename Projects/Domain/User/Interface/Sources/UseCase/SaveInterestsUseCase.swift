//
//  SaveInterestsUseCase.swift
//  DomainUserInterface
//
//  Created by 윤지호 on 4/5/24.
//

import Foundation
import RxSwift

public protocol SaveInterestsUseCase {
  func execute(interests: [Interest]) -> Single<Bool>
}
