//
//  SaveProfileImageUseCase.swift
//  DomainUserInterface
//
//  Created by 윤지호 on 5/14/24.
//

import Foundation
import RxSwift

public protocol SaveProfileImageUseCase {
  func execute(image: Data) -> Single<UserProfile>
}
