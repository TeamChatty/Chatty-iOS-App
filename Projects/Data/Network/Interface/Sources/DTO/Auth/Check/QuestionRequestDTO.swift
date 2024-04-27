//
//  QuestionRequestDTO.swift
//  DataNetworkInterface
//
//  Created by HUNHIE LEE on 23.04.2024.
//

import Foundation

public enum AuthCheckType {
  case nickname
  case birth
}

public struct QuestionRequestDTO {
  public let checkType: AuthCheckType
  public let body: QuestionRequestBody
  
  public init(checkType: AuthCheckType, body: QuestionRequestBody) {
    self.checkType = checkType
    self.body = body
  }
  
  public struct QuestionRequestBody: Encodable {
    let mobileNumber: String
    
    enum CodingKeys: String, CodingKey {
      case mobileNumber
    }
    
    public init(mobileNumber: String) {
      self.mobileNumber = mobileNumber
    }
  }
}
