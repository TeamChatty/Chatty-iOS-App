//
//  UserProfileRepositoryProtocol.swift
//  DomainUserInterface
//
//  Created by 윤지호 on 1/29/24.
//

import Foundation
import RxSwift
import DomainCommon

public protocol UserProfileRepositoryProtocol {
  func saveUserProfile(userProfile: UserProfile)
  func getUserProfile() -> UserProfile
  func saveAllInterests(interests: Interests)
}
