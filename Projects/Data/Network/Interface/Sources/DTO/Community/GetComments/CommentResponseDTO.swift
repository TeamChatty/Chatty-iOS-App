//
//  CommentResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation

public struct CommentResponseDTO: Decodable {
  public let postId: Int
  public let commentId: Int
  public let content: String
  public let createdAt: String // "2024-04-17T01:18:20.256Z",
  public let childCount: Int
  public let userId: Int
  public let nickname: String
  public let imageUrl: String
}
