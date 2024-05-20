//
//  WriteFeedUseCase.swift
//  DomainCommunityInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation
import RxSwift

public protocol WriteFeedUseCase {
  func execute(content: String, images: [Data]) -> Observable<WritedFeed>
}
