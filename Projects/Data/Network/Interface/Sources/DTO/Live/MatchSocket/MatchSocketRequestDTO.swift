//
//  MatchSocketRequestDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 3/4/24.
//

import Foundation
import DomainLiveInterface

public struct MatchSocketRequestDTO: Codable {
  let id: Int
  let userId: Int
  let nickname: String
  let gender: String
  let mbti: String
  let address: String?
  let imageUrl: String?
  let age: Int
  let blueCheck: Bool
  let requestMinAge: Int
  let requestMaxAge: Int
  let requestCategory: String
  let requestScope: Int?
  let requestGender: String
  let requestBlueCheck: Bool
  let success: Bool
  
  public init(id: Int, userId: Int, nickname: String, gender: String, mbti: String, address: String, imageUrl: String?, age: Int, blueCheck: Bool, requestMinAge: Int, requestMaxAge: Int, requestCategory: String, requestScope: Int, requestGender: String, requestBlueCheck: Bool, success: Bool) {
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
  
  public init(matchCondition: MatchResult) {
    self.id = matchCondition.id
    self.userId = matchCondition.userId
    self.nickname = matchCondition.nickname
    self.gender = matchCondition.gender
    self.mbti = matchCondition.mbti
    self.address = matchCondition.address
    self.imageUrl = matchCondition.imageUrl
    self.age = matchCondition.age
    self.blueCheck = matchCondition.blueCheck
    self.requestMinAge = matchCondition.requestMinAge
    self.requestMaxAge = matchCondition.requestMaxAge
    self.requestCategory = matchCondition.requestCategory
    self.requestScope = matchCondition.requestScope
    self.requestGender = matchCondition.requestGender
    self.requestBlueCheck = matchCondition.requestBlueCheck
    self.success = matchCondition.success
  }
  
  public func toDomain() -> MatchResult {
    return MatchResult(
      id: self.id,
      userId: self.userId,
      nickname: self.nickname,
      gender: self.gender,
      mbti: self.mbti,
      address: self.address,
      imageUrl: self.imageUrl,
      age: self.age,
      blueCheck: self.blueCheck,
      requestMinAge: self.requestMinAge,
      requestMaxAge: self.requestMaxAge,
      requestCategory: self.requestCategory,
      requestScope: self.requestScope,
      requestGender: self.requestGender,
      requestBlueCheck: self.requestBlueCheck,
      success: self.success
    )
  }
  
  public func toDictionary() -> [String: Any?] {
    return [
      "id": self.id,
      "userId": self.userId,
      "nickname": self.nickname,
      "gender": self.gender,
      "mbti": self.mbti,
      "address": self.address,
      "imageUrl": self.imageUrl,
      "age": self.age,
      "blueCheck": self.blueCheck,
      "requestMinAge": self.requestMinAge,
      "requestMaxAge": self.requestMaxAge,
      "requestCategory": self.requestCategory,
      "requestScope": self.requestScope,
      "requestGender": self.requestGender,
      "requestBlueCheck": self.requestBlueCheck,
      "success": self.success
    ]
  }
}
