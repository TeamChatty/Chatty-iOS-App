//
//  MatchResult.swift
//  DomainCommonInterface
//
//  Created by 윤지호 on 2/13/24.
//

import Foundation

public struct MatchResult {
  public let id: Int
  public let userId: Int
  public let nickname: String
  public let gender: String
  public let mbti: String
  public let address: String?
  public let imageUrl: String?
  public let age: Int
  public let blueCheck: Bool
  public let requestMinAge: Int
  public let requestMaxAge: Int
  public let requestCategory: String
  public let requestScope: Int?
  public let requestGender: String
  public let requestBlueCheck: Bool
  public let success: Bool
  
  public init(id: Int, userId: Int, nickname: String, gender: String, mbti: String, address: String?, imageUrl: String?, age: Int, blueCheck: Bool, requestMinAge: Int, requestMaxAge: Int, requestCategory: String, requestScope: Int?, requestGender: String, requestBlueCheck: Bool, success: Bool) {
    self.id = id
    self.userId = userId
    self.nickname = nickname
    self.gender = gender
    self.mbti = mbti
    self.address = address
    self.imageUrl = imageUrl
    self.age = age
    self.blueCheck = blueCheck
    self.requestMinAge = requestMinAge
    self.requestMaxAge = requestMaxAge
    self.requestCategory = requestCategory
    self.requestScope = requestScope
    self.requestGender = requestGender
    self.requestBlueCheck = requestBlueCheck
    self.success = success
  }
}
