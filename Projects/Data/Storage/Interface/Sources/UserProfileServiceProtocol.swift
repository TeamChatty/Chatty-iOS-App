//
//  UserProfileServiceProtocol.swift
//  DataStorageInterface
//
//  Created by HUNHIE LEE on 2/1/24.
//

import Foundation
import DomainUserInterface

public protocol UserProfileServiceProtocol {
  func getData() -> UserProfile
  func setData(userProfile: UserProfile)
  func saveAllInterests(interests: Interests)
}
