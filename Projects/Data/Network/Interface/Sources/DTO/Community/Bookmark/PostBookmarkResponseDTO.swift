//
//  PostBookmarkResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 5/1/24.
//

import Foundation

public struct PostBookmarkResponseDTO: CommonResponseDTO {
  public typealias Data = ResponseDTO
  public var code: Int
  public var status: String
  public var message: String
  public var data: Data
  
  
  public struct ResponseDTO: Decodable {
    public var bookmarkId: Int
    public var postId: Int
    public var userId: Int
    public var writerId: Int
  }
}
