//
//  UserDataRepositoryProtocol.swift
//  DomainUserInterface
//
//  Created by 윤지호 on 1/29/24.
//

import Foundation
import RxSwift

public protocol UserDataRepositoryProtocol {
  func saveUserData(userData: UserProfile)
  func getUserData() -> UserProfile
  func saveAllInterests(interests: Interests)
}
