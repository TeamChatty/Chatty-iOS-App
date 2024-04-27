//
//  WriteFeedRequestDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation

public struct WriteFeedRequestDTO: Encodable {
  public let title: String
  public let content: String
  public let images: [Data]
 
  public init(title: String, content: String, images: [Data]) {
    self.title = title
    self.content = content
    self.images = images
  }
}
