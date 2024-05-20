//
//  GetFeedResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 5/4/24.
//

import Foundation
import DomainCommunityInterface

public struct GetFeedResponseDTO: CommonResponseDTO {
  public typealias Data = ResponseDTO
  public var code: Int
  public var status: String
  public var message: String
  public var data: Data
  
  public func toDomain() -> Feed {
    return data.toDomain()
  }
  
  public struct ResponseDTO: Decodable {
    public let postId: Int
    public let content: String
    public let viewCount: Int
//    public let createdAt: String // "2024-04-17T00:08:31.268Z"
    public let userId: Int
    public let nickname: String
    public let profileImage: String?
    public let postImages: [String]

    public let likeCount: Int
    public let commentCount: Int
    public let like: Bool
    public let owner: Bool
    public let bookmark: Bool
    
    public func toDomain() -> Feed {
      return Feed(postId: postId, content: content, viewCount: viewCount, createdAt: "", userId: userId, nickname: nickname, imageUrl: profileImage, postImages: postImages, owner: owner, likeCount: likeCount, commentCount: commentCount, like: like, bookmark: bookmark)
    }
  }
}
