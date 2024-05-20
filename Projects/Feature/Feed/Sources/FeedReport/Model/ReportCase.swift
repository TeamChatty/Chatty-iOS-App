//
//  ReportCase.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/4/24.
//

import Foundation
import SharedDesignSystem

enum ReportCase: Int, IntCaseIterable {
  case inappropriateArticle
  case sns
  case disturbance
  case hatefulWriting
  case falseInformation
  case advertisingAndSpam
  case referenceToAnotherPerson

  
  
  
  static func getCase(name: String) -> ReportCase {
    switch name {
    case "부적절한/성적인 글 및 사진 게시":
      return .inappropriateArticle
    case "SNS 및 연락처 기재":
      return .sns
    case "분란/다툼 조장":
      return .disturbance
    case "욕설 및 혐오 발언 등 폭력적인 글 게시":
      return .hatefulWriting
    case "사기, 거짓 정보 게시":
      return .falseInformation
    case "광고 및 스팸":
      return .advertisingAndSpam
    case "타인 닉네임 언급/저격":
      return .referenceToAnotherPerson
    default:
      return .inappropriateArticle
    }
  }
    
  var stringKR: String {
    switch self {
    case .inappropriateArticle:
      return "부적절한/성적인 글 및 사진 게시"
    case .sns:
      return "SNS 및 연락처 기재"
    case .disturbance:
      return "분란/다툼 조장"
    case .hatefulWriting:
      return "욕설 및 혐오 발언 등 폭력적인 글 게시"
    case .falseInformation:
      return "사기, 거짓 정보 게시"
    case .advertisingAndSpam:
      return "광고 및 스팸"
    case .referenceToAnotherPerson:
      return "타인 닉네임 언급/저격"
    }
  }
}
