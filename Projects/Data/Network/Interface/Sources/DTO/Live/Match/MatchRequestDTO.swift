//
//  MatchRequestDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 3/4/24.
//

import Foundation

public struct MatchRequestDTO: Encodable {
  var minAge: Int
  var maxAge: Int
  var gender: String
  var scope: Int?
  var category: String
  var blueCheck: Bool
  
  public init(minAge: Int, maxAge: Int, gender: String, scope: Int? = nil, category: String, blueCheck: Bool) {
    self.minAge = minAge
    self.maxAge = maxAge
    self.gender = gender
    self.scope = scope
    self.category = category
    self.blueCheck = blueCheck
  }
}
