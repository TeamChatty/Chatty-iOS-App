//
//  SendVerificationCodeUseCase.swift
//  DomainAuthInterface
//
//  Created by HUNHIE LEE on 2/2/24.
//

import Foundation
import RxSwift

public protocol SendVerificationCodeUseCase {
  func execute(mobileNumber: String) -> Single<Int>
}
