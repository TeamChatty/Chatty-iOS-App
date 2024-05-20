//
//  LeaveAccountUseCase.swift
//  DomainUserInterface
//
//  Created by 윤지호 on 4/30/24.
//

import Foundation
import RxSwift

/// 회원 탈퇴
public protocol LeaveAccountUseCase {
  func execute() -> Observable<Void>
}
