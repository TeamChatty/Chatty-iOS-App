//
//  ChatParticipantType.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 2/14/24.
//

import Foundation

public enum ChatParticipantType: Hashable {
  case currentUser
  case participant(ParticipantProfile)
  
  public struct ParticipantProfile: Hashable {
    public var name: String
    public var imageURL: String?
    
    public init(name: String, imageURL: String? = nil) {
      self.name = name
      self.imageURL = imageURL
    }
  }
}
