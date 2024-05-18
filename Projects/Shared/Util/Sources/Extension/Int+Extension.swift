//
//  Int+Extension.swift
//  SharedUtil
//
//  Created by HUNHIE LEE on 6.05.2024.
//

import Foundation

public extension Int {
  func formatToKRW() -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencySymbol = "₩"
    
    return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
  }
}
