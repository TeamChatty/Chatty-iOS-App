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
  
  private var userData: UserProfile = .init(nickname: nil, mobileNumber: "", authority: .anonymous, blueCheck: false)
  private var allInterests: [Interest] = []
  
  private init() { }
    
  public func getData() -> UserProfile {
    return userData
  }
  
  public func setData(userData: UserProfile) {
    var userData = userData
    userData.interests = userData.interests.map { interest in
      guard let index = allInterests.firstIndex(where: { $0.id == interest.id} ) else { return interest }
      return allInterests[index]
    }
    print("userdata - \(userData.interests)")
    self.userData = userData
  }
  
  public func saveAllInterests(interests: Interests) {
    self.allInterests = interests.interests
    self.userData.interests = userData.interests.map { interest in
      guard let index = allInterests.firstIndex(where: { $0.name == interest.name } ) else { return interest }
      return allInterests[index]
    }
  }
}
