//
//  UserProfileService.swift
//  DataStorage
//
//  Created by 윤지호 on 1/28/24.
//

import Foundation
import DataStorageInterface
import DomainUserInterface

public final class UserProfileService: UserProfileServiceProtocol {
  public static let shared = UserProfileService()
  
  private var userProfile: UserProfile = .init(userId: 0, nickname: nil, mobileNumber: "", authority: .anonymous, blueCheck: false)
  private var allInterests: [Interest] = []
  
  private init() { }
    
  public func getData() -> UserProfile {
    return userProfile
  }
  
  public func setData(userProfile: UserProfile) {
    var userProfile = userProfile
    userProfile.interests = userProfile.interests.map { interest in
      guard let index = allInterests.firstIndex(where: { $0.id == interest.id} ) else { return interest }
      return allInterests[index]
    }
    print("userdata - \(userProfile.interests)")
    self.userProfile = userProfile
  }
  
  public func resetProfile() {
    self.userProfile = UserProfile(userId: 0, nickname: nil, mobileNumber: "", authority: .user, blueCheck: false)
  }
  
  public func saveAllInterests(interests: Interests) {
    self.allInterests = interests.interests
    self.userProfile.interests = userProfile.interests.map { interest in
      guard let index = allInterests.firstIndex(where: { $0.name == interest.name } ) else { return interest }
      return allInterests[index]
    }
  }
}
