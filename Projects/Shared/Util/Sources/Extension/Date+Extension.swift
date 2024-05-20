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
  
  public static var shared: Date {
    let now = Date()
    let timezone = TimeZone.autoupdatingCurrent
    let secondsFromGMT = timezone.secondsFromGMT(for: now)
    let localizedDate = now.addingTimeInterval(TimeInterval(secondsFromGMT))
    return localizedDate
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
    let currentDate = Date.shared
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
    let currentDate = Date.shared
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
    let currentDate = Date.shared
    let tenMinutesAfterCurrentDate = Calendar.current.date(byAdding: .second, value: 600, to: currentDate)!
    print("10분 초과 여부 \(self > tenMinutesAfterCurrentDate)")
    return self > tenMinutesAfterCurrentDate
  }
  
  public func formatRelativeDate() -> String {
    let now = Date.shared
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: now)
    
    if let day = components.day, day > 6 {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy. MM. dd"
      return formatter.string(from: self)
    }
    
    if let day = components.day, day >= 1 {
      return "\(day)일 전"
    }
    
    if let hour = components.hour, hour >= 1 {
      return "\(hour)시간 전"
    }
    
    if let minute = components.minute, minute >= 1 {
      return "\(minute)분 전"
    }
    
    return "방금 전"
  }
}
