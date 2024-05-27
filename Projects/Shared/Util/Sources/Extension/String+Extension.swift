//
//  String+Extension.swift
//  SharedDesignSystem
//
//  Created by walkerhilla on 1/9/24.
//

import Foundation

public extension String {
  /// 문자열이 숫자일 경우 __전화번호 형식(010-0000-0000)__ 으로 반환해요.
  func formattedPhoneNumber() -> String {
    let digits = self.filter { $0.isNumber }
    
    guard digits.count == 11 else { return self }
    
    let areaCode = digits.prefix(3)
    let middle = digits.dropFirst(3).prefix(4)
    let last = digits.dropFirst(7)
    
    return "\(areaCode)-\(middle)-\(last)"
  }
  
  func toJSON() -> Any? {
    guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
    return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
  }
  
  func toDateFromISO8601() -> Date? {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime]
    dateFormatter.timeZone = TimeZone.autoupdatingCurrent
    return dateFormatter.date(from: self)
  }
  
  func toDate() -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    return dateFormatter.date(from: self)
  }
  
  func toTimeDifference() -> String {
    guard let standardTime = self.toDateFromISO8601() else { return "" }
    
    let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from:  standardTime, to: Date.shared)
    
    if let year = component.year,
       let month = component.month,
       let day = component.day,
       let hour = component.hour {
     
      if year > 0 {
        return "\(year)년 전"
      }
      if month > 0 {
        return "\(month)달 전"
      }
      if day > 0 {
        return "\(day)일 전"
      }
      
      /// Xcode 오류인지 현재 시간이 잘못 입력됨.
      if hour + 9 > 0 {
        return "\(hour + 9)시간 전"
      }
      
      if let minute = component.minute {
        if minute > 0 {
          return "\(minute)분 전"
        } else {
          return "방금 전"
        }
      }
      return "\(year)년 \(month)월 \(day)일 \(hour)시간 \(month)분 만큼 차이남"
    } else {
      return ""
    }

  }
}
