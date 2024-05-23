//
//  GetCommnetsRequestDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 5/10/24.
//

import Foundation

public struct GetCommnetsRequestDTO {
  public let postId: Int
  public let lastCommentId: Int64
  public let size: Int
  
  public init(postId: Int, lastCommentId: Int64, size: Int) {
    self.postId = postId
    self.lastCommentId = lastCommentId
    self.size = size
  }
}
