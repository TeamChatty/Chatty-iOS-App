//
//  GetFeedResponseDTO.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation

struct GetFeedRequestDTO: CommonResponseDTO {
  typealias Data = FeedResponseDTO
  var code: Int
  var status: String
  var message: String
  var data: Data
}
