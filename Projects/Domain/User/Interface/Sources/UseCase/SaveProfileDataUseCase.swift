//
//  SaveProfileDataUseCase.swift
//  DomainUser
//
//  Created by 윤지호 on 2/19/24.
//

import Foundation
import RxSwift
import DomainCommon

public protocol SaveProfileDataUseCase {
  func executeObs(
    gender: String,
    birth: String,
    imageData: Data?,
    interests: [Interest],
    mbti: String
  ) -> Observable<UserProfile>
}
