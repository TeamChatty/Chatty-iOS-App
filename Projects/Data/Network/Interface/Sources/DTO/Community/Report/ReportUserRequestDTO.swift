//
//  ReportUserRequestDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 5/24/24.
//

import Foundation

public struct ReportUserRequestDTO: Encodable {
  public let content: String
  
  public init(content: String) {
    self.content = content
  }
}
