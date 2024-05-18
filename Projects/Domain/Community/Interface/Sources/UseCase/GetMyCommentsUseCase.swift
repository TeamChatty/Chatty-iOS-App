//
//  GetMyCommentsUseCase.swift
//  DomainCommunityInterface
//
//  Created by 윤지호 on 5/18/24.
//

import Foundation
import RxSwift

public protocol GetMyCommentsUseCase {
  func execute(lastCommentId: Int64, size: Int) -> Observable<[Comment]>
}
