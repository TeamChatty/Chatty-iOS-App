//
//  WriteCommonCommentReqeustDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation

public struct WriteCommonCommentReqeustDTO: Encodable {
  let content: String
  
  public init(content: String) {
    self.content = content
  }
}
