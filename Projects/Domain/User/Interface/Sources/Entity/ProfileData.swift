//
//  ProfileData.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 2/23/24.
//

import Foundation

public struct ProfileData: Hashable {
  public let userId: Int
  public let name: String
  public let profileImageURL: String?
  
  public init(userId: Int, name: String, profileImageURL: String?) {
    self.userId = userId
    self.name = name
    self.profileImageURL = profileImageURL
  }
}
