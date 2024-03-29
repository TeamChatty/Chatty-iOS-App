//
//  DefaultUserDataRepository.swift
//  DataRepository
//
//  Created by 윤지호 on 1/29/24.
//

import Foundation
import RxSwift
import DataStorageInterface
import DataRepositoryInterface
import DomainUserInterface

public final class DefaultUserDataRepository: UserDataRepository {
  
  private let userDataService: any UserProfileServiceProtocol
  
  public init(userDataService: any UserProfileServiceProtocol) {
    self.userDataService = userDataService
  }
  
  public func saveUserData(userData: UserProfile) {
    userDataService.setData(userData: userData)
  }
  
  public func getUserData() -> UserProfile {
    return userDataService.getData()
  }
  
  public func saveAllInterests(interests: Interests) {
    userDataService.saveAllInterests(interests: interests)
  }
}
