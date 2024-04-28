//
//  CommonProfile.swift
//  SharedDesignSystem
//
//  Created by 윤지호 on 4/28/24.
//

import UIKit

public enum CommonProfileScale {
  case s36
  case s44
  case s48
  case s140
  case s375
  
  public var toInt: Int {
    switch self {
    case .s36:
      return 36
    case .s44:
      return 44
    case .s48:
      return 48
    case .s140:
      return 140
    case .s375:
      return 370
    }
  }
}
public enum CommonProfile: String {
  case Man
  case Profile
  
  public func getProfileImage(scale: CommonProfileScale) -> UIImage {

    switch self {
    case .Man:
      switch scale {
      case .s36:
        return Images.manProfile36.image
      case .s44:
        return Images.manProfile44.image
      case .s48:
        return Images.manProfile48.image
      case .s140:
        return Images.manProfile140.image
      case .s375:
        return Images.manProfile375.image
      }
    case .Profile:
      switch scale {
      case .s36:
        return Images.womanProfile36.image
      case .s44:
        return Images.womanProfile44.image
      case .s48:
        return Images.womanProfile48.image
      case .s140:
        return Images.womanProfile140.image
      case .s375:
        return Images.womanProfile375.image
      }
    }
  }
}
