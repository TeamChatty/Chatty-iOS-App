//
//  LogoutUseCase.swift
//  DomainUserInterface
//
//  Created by 윤지호 on 4/30/24.
//

import Foundation
import RxSwift

/// 로그아웃
public protocol LogoutUseCase {
  func execute() -> Observable<Void>
}
