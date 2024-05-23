//
//  GetRepliesRequestDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 5/10/24.
//

import Foundation

public struct GetRepliesRequestDTO {
  public let commentId: Int
  public let lastCommentId: Int64
  public let size: Int
  
  public init(commentId: Int, lastCommentId: Int64, size: Int) {
    self.commentId = commentId
    self.lastCommentId = lastCommentId
    self.size = size
  }
}
