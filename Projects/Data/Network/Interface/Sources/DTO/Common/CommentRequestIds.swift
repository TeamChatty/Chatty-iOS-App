//
//  CommentRequestIds.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation

public struct CommentRequestIds {
  let postId: Int
  let commentId: Int
  
  public init(postId: Int, commentId: Int) {
    self.postId = postId
    self.commentId = commentId
  }
}
