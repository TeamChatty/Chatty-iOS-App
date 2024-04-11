//
//  SaveAddressUseCase.swift
//  DomainUserInterface
//
//  Created by 윤지호 on 4/5/24.
//

import Foundation
import RxSwift

public protocol SaveAddressUseCase {
  func execute(address: String) -> Single<Bool>
}
