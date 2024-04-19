//
//  WritedFeed.swift
//  DomainCommunityInterface
//
//  Created by 윤지호 on 4/19/24.
//

import Foundation

public struct WritedFeed {
  public let id: Int
  public let title: String
  public let content: String
  public let userId: Int
  public let nickname:String
  public let profileImage: String
  public let postImages: [String]
  public let viewCount: Int
  
  public init(id: Int, title: String, content: String, userId: Int, nickname: String, profileImage: String, postImages: [String], viewCount: Int) {
    self.id = id
    self.title = title
    self.content = content
    self.userId = userId
    self.nickname = nickname
    self.profileImage = profileImage
    self.postImages = postImages
    self.viewCount = viewCount
  }
}
