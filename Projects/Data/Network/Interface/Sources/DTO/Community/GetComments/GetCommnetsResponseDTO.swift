//
//  GetCommnetsResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation
import DomainCommunityInterface

public struct GetCommnetsResponseDTO: CommonResponseDTO {
  public typealias Data = [CommentResponseDTO]
  public var code: Int
  public var status: String
  public var message: String
  public var data: [CommentResponseDTO]
  
  public func toDomain() -> [Comment] {
    return data.map { $0.toDomain() }
  }
}
