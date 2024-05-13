//
//  WriteReplyResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation
import DomainCommunityInterface

public struct WriteReplyResponseDTO: CommonResponseDTO {
  public typealias Data = WriteReplyDataResponseDTO
  public let code: Int
  public let status: String
  public let message: String
  public var data: WriteReplyDataResponseDTO
  
  public func toDomain(parentId: Int) -> Reply {
    return data.toDomain(parentId: parentId)
  }
}

public struct WriteReplyDataResponseDTO: Decodable {
  public let commentId: Int
  public let postId: Int
  public let userId: Int
  public let content: String
  
  /// UseCase에서 UserProfile을 불러와 수정
  public func toDomain(parentId: Int) -> Reply {
    return Reply(postId: postId, commentId: commentId, parentId: parentId, content: content, createdAt: "", userId: userId, nickname: "", imageUrl: nil, likeCount: 0, like: false, owner: true)
  }
}
