//
//  GetRepliesResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation

public struct GetRepliesResponseDTO: CommonResponseDTO {
  public typealias Data = [ReplyResponseDTO]
  public var code: Int
  public var status: String
  public var message: String
  public var data: [ReplyResponseDTO]
}
