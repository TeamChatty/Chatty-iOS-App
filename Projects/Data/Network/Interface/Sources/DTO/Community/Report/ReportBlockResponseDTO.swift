//
//  ReportBlockResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 5/3/24.
//

import Foundation

public struct ReportBlockResponseDTO: CommonResponseDTO {
  public typealias Data = ResponseDTO
  public let code: Int
  public let status: String
  public let message: String
  public var data: Data
  
  public struct ResponseDTO: Decodable {
    public let blockId: Int
    public let blockerId: Int
    public let blockedId: Int
  }
}

