//
//  GetMyCommentRequestDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 5/18/24.
//

import Foundation

public struct GetMyCommnetsRequestDTO {
  public let lastCommentId: Int64
  public let size: Int
  
  public init(lastCommentId: Int64, size: Int) {
    self.lastCommentId = lastCommentId
    self.size = size
  }
}
