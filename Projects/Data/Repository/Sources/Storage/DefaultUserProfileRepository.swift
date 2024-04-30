//
//  DefaultUserProfileRepository.swift
//  DataRepository
//
//  Created by 윤지호 on 1/29/24.
//

import Foundation
import RxSwift
import DataStorageInterface
import DataRepositoryInterface
import DomainUserInterface

public final class DefaultUserProfileRepository: UserProfileRepository {
  
  private let userProfileService: any UserProfileServiceProtocol
  
  public init(userProfileService: any UserProfileServiceProtocol) {
    self.userProfileService = userProfileService
  }
  
  public func saveUserProfile(userProfile: UserProfile) {
    userProfileService.setData(userProfile: userProfile)
  }
  
  public func getUserProfile() -> UserProfile {
    return userProfileService.getData()
  }
  
  public func resetProfile() {
    return userProfileService.resetProfile()
  }
  
  public func saveAllInterests(interests: Interests) {
    userProfileService.saveAllInterests(interests: interests)
  }
}
