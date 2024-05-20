//
//  WriteFeedRequestDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation

public struct WriteFeedRequestDTO: Encodable {
  public let content: String
  public let images: [Data]
 
  public init(content: String, images: [Data]) {
    self.content = content
    self.images = images
  }
}
