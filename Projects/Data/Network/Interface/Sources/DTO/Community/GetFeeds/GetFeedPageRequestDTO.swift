//
//  GetFeedPageRequestDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 4/27/24.
//

import Foundation

public struct GetFeedPageRequestDTO: Encodable {
  public var lastPostId: Int
  public var size: Int
  
  public init(lastPostId: Int, size: Int) {
    self.lastPostId = lastPostId
    self.size = size
  }
}
