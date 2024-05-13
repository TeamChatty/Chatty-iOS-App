//
//  CommentLikeResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 5/13/24.
//

import Foundation


public struct CommentLikeResponseDTO: CommonResponseDTO {
  public typealias Data = ResponseDTO
  public var code: Int
  public var status: String
  public var message: String
  public var data: Data
  
  
  public struct ResponseDTO: Decodable {
    public var commentLikeId: Int
    public var commentId: Int
    public var userId: Int
    public var writerId: Int
  }
}

