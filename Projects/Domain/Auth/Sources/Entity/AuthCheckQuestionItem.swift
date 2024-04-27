//
//  AuthCheckQuestionItem.swift
//  DomainAuth
//
//  Created by HUNHIE LEE on 24.04.2024.
//

import Foundation

public struct AuthCheckQuestionItem {
  public let id: Int
  public let title: String
  
  public init(id: Int, title: String) {
    self.id = id
    self.title = title
  }
}
