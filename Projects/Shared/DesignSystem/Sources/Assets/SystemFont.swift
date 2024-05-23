//
//  SystemFont.swift
//  SharedDesignSystem
//
//  Created by 윤지호 on 1/3/24.
//

import UIKit

public enum SystemFont {
  /// H1_Bold / 26
  case headLine01
  /// H2_SemiBold / 24
  case headLine02
  /// T1_Regular / 20
  case title01
  /// T2_SemiBold / 18
  case title02
  /// T3_SemiBold / 16
  case title03
  /// T4_Regular / 16
  case title04
  /// B1_SemiBold / 14
  case body01
  /// B2_Medium / 14
  case body02
  /// B1_Regular / 14 << 피그마 수정건의사항
  case body03
  /// C1_SemiBold / 13
  case caption01
  /// C2_Regular / 13
  case caption02
  /// C3_Regular / 12
  case caption03
  
  public var font: UIFont {
    switch self {
    case .headLine01:
      Font.Pretendard(.Bold).of(size: 26)
    case .headLine02:
      Font.Pretendard(.SemiBold).of(size: 24)
    case .title01:
      Font.Pretendard(.Regular).of(size: 20)
    case .title02:
      Font.Pretendard(.SemiBold).of(size: 18)
    case .title03:
      Font.Pretendard(.SemiBold).of(size: 16)
    case .title04:
      Font.Pretendard(.Regular).of(size: 16)
    case .body01:
      Font.Pretendard(.SemiBold).of(size: 14)
    case .body02:
      Font.Pretendard(.Medium).of(size: 14)
    case .body03:
      Font.Pretendard(.Regular).of(size: 14)
    case .caption01:
      Font.Pretendard(.SemiBold).of(size: 13)
    case .caption02:
      Font.Pretendard(.Regular).of(size: 13)
    case .caption03:
      Font.Pretendard(.Regular).of(size: 12)
    }
  }
}
