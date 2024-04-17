//
//  WriteReplyResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation

public struct WriteReplyResponseDTO: CommonResponseDTO {
  public typealias Data = WriteCommentDataResponseDTO
  public let code: Int
  public let status: String
  public let message: String
  public var data: WriteCommentDataResponseDTO
}

public struct WriteReplyDataResponseDTO: Decodable {
  public let commentId: Int
  public let postId: Int
  public let userId: Int
  public let content: String
}
