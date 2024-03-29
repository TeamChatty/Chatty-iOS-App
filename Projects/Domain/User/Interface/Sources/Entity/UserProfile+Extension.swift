//
//  UserProfile+Extension.swift
//  DomainUserInterface
//
//  Created by 윤지호 on 3/25/24.
//

import Foundation
import SharedUtil

extension UserProfile {
  public var genderStringKR: String {
    switch self.gender {
    case .male:
      return "남"
    case .female:
      return "여"
    default:
      return ""
    }
  }
  
  /// 만나이
  public var americanAge: Int {
    if let birth {
      return Date().toAmericanAge(birth)
    } else {
      return 0
    }
  }
}
