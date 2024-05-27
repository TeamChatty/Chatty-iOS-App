//
//  ReportUserResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 5/28/24.
//

import Foundation

public struct ReportUserResponseDTO: CommonResponseDTO {
  public typealias Data = ResponseDTO
  public let code: Int
  public let status: String
  public let message: String
  public var data: Data
  
  public struct ResponseDTO: Decodable {
    public let reportId: Int
    public let reporterId: Int
    public let reportedId: Int
    public let content: String
  }
}
