//
//  QuestionResponseDTO.swift
//  DataNetworkInterface
//
//  Created by HUNHIE LEE on 23.04.2024.
//

import Foundation

public struct QuestionResponseDTO: Decodable {
  public let code: Int
  public let status: String
  public let message: String
  public let data: DataClass
  
  public struct DataClass: Decodable {
    let problem: [String]
  }
  
  public func toDomain() -> [String] {
    return data.problem
  }
}
