//
//  DateFormatter+Extension.swift
//  SharedUtil
//
//  Created by 윤지호 on 2/23/24.
//

import Foundation

extension Date {
  private static let dateFormatter = DateFormatter()
  
  public enum DateFormatType {
    case ahhmm
    
    var formatString: String {
      switch self {
      case .ahhmm:
        return "a hh:mm"
      }
    }
  }
  
  /// "yyyy-MM-dd" -> Date
  public func toDate(_ yearMonthDay: String) -> Date {
    let dateFormatter = Self.dateFormatter
    dateFormatter.dateFormat = "yyyy-MM-dd"
    guard let convertedDate = dateFormatter.date(from: yearMonthDay) else {
      return Date.now
    }
    return convertedDate
  }
  
  /// Date -> "yyyy-MM-dd"
  public func toStringYearMonthDay() -> String {
    let dateFormatter = Self.dateFormatter
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let convertedDate = dateFormatter.string(from: self)
    return convertedDate
  }
  
  public func toCustomString(format: DateFormatType) -> String {
    let formatter = Self.dateFormatter
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = format.formatString
    return formatter.string(from: self)
  }
  
  /// "yyyy-MM-dd" > 만나이
  public func toAmericanAge(_ string: String) -> Int {
    let birthDate = string.split(separator: "-").map{ Int($0)! }
    let currentDate = Date.now.toStringYearMonthDay().split(separator: "-").map{ Int($0)! }
    
    let birthYear = birthDate[0]
    let birthMonth = birthDate[1]
    let birthDay = birthDate[2]
    let currentYear = currentDate[0]
    let currentMonth = currentDate[1]
    let currentDay = currentDate[2]
    print("string - \(string) / currentYear - \(currentYear), birthYear - \(birthYear)")
    if currentMonth > birthMonth {
      return currentYear - birthYear
    } else if currentMonth == birthMonth && currentDay >= birthDay {
      return currentYear - birthYear
    } else {
      return currentYear - birthYear - 1
    }
  }
}
