//
//  DateFormatter+Extension.swift
//  SharedUtil
//
//  Created by 윤지호 on 2/23/24.
//

import Foundation
import Then

extension Date {
  private static let dateFormatter = DateFormatter().then {
    $0.timeZone = .autoupdatingCurrent
  }
  
  public enum DateFormatType {
    case ahhmm
    case yyyyMMddKorean
    
    var formatString: String {
      switch self {
      case .ahhmm:
        return "a hh:mm"
      case .yyyyMMddKorean:
        return "yyyy년 MM월 dd일"
      }
    }
  }
  
  public func isToday() -> Bool {
    // 현재 날짜 가져오기
    let currentDate = Date()
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: currentDate)
    let targetDay = calendar.startOfDay(for: self)
    
    if today == targetDay {
      return true
    } else {
      return false
    }
  }
  
  public func toCustomString() -> String {
    let calendar = Calendar.current
    let currentDate = Date()
    let targetDay = calendar.startOfDay(for: self)
    let today = calendar.startOfDay(for: currentDate)
    let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
    
    if today == targetDay {
      return self.toCustomString(format: .ahhmm)
    } else if today == yesterday {
      return "Yesterday"
    } else {
      Date.dateFormatter.dateFormat = "MMMM dd"
      return Date.dateFormatter.string(from: self)
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
  
  public func dateOnly() -> Date? {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: self)
    return calendar.date(from: components)
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
  
  public func toMinuteComponents() -> DateComponents {
    let calendar = Calendar.current
    return calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
  }
  
  public func isDateMoreThanTenMinutesAhead() -> Bool {
      let currentDate = Date()
      let tenMinutesAfterCurrentDate = Calendar.current.date(byAdding: .minute, value: 10, to: currentDate)!
      
      return self > tenMinutesAfterCurrentDate
  }
}
