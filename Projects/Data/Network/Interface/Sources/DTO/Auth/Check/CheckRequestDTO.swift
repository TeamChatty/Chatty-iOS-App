//
//  CheckRequestDTO.swift
//  DataNetworkInterface
//
//  Created by HUNHIE LEE on 23.04.2024.
//

import Foundation
import DomainAuthInterface

public struct CheckRequestDTO {
  public let checkType: AuthCheckType
  public let body: CheckRequestBody
  
  public init(checkType: AuthCheckType, body: CheckRequestBody) {
    self.checkType = checkType
    self.body = body
  }
  
  public struct CheckRequestBody: Encodable {
    let mobileNumber: String
    let answer: String
    
    public init(mobileNumber: String, answer: String) {
      self.mobileNumber = mobileNumber
      self.answer = answer
    }
  }
}
