//
//  ReportUseCase.swift
//  DomainCommunityInterface
//
//  Created by 윤지호 on 5/3/24.
//

import Foundation
import RxSwift

public protocol ReportUseCase {
  func executeBlock(userId: Int) -> Observable<Int>
  func executeReport(userId: Int, content: String) -> Observable<Int>
}
