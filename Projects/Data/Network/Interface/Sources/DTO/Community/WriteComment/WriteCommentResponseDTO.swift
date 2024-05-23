//
//  WriteCommentResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation
import DomainCommunityInterface

public struct WriteCommentResponseDTO: CommonResponseDTO {
  public typealias Data = WriteCommentDataResponseDTO
  public let code: Int
  public let status: String
  public let message: String
  public var data: WriteCommentDataResponseDTO
  
  public func toDomain() -> Comment {
    return data.toDomain()
  }
}

public struct WriteCommentDataResponseDTO: Decodable {
  public let commentId: Int
  public let postId: Int
  public let userId: Int
  public let content: String
  
  /// UseCase에서 UserProfile을 불러와 수정
  public func toDomain() -> Comment {
    return Comment(postId: postId, commentId: commentId, content: content, createdAt: "", childCount: 0, userId: userId, nickname: "", imageUrl: nil, likeCount: 0, like: false, owner: true)
  }
}
