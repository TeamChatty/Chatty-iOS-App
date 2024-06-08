//
//  AuthNumber.swift
//  DomainAuthInterface
//
//  Created by 윤지호 on 6/8/24.
//

import Foundation

public struct AuthNumber {
  public let authNumber: String
  public let limitNumber: Int
  
  public init(authNumber: String, limitNumber: Int) {
    self.authNumber = authNumber
    self.limitNumber = limitNumber
  }
}
