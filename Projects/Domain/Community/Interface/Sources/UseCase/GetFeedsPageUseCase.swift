//
//  GetFeedsPageUseCase.swift
//  DomainCommunityInterface
//
//  Created by 윤지호 on 4/27/24.
//

import Foundation
import RxSwift

public protocol GetFeedsPageUseCase {
  func execute(lastPostId: Int, size: Int) -> Observable<[Feed]>
}
