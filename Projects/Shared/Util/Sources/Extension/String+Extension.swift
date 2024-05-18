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
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    return dateFormatter.date(from: self)
  }
  
  func toDate() -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    return dateFormatter.date(from: self)
  }
}
