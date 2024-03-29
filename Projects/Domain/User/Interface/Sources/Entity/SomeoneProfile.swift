//
//  SomeoneProfile.swift
//  DomainUserInterface
//
//  Created by HUNHIE LEE on 2/26/24.
//

import Foundation

public struct SomeoneProfile {
  public let profile: UserProfile
  public let unlock: Bool
  
  public init(profile: UserProfile, unlock: Bool) {
    self.profile = profile
    self.unlock = unlock
  }
}
