//
//  AddedImage.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/23/24.
//

import UIKit

public struct AddedImage: Equatable {
  let id: String = UUID().uuidString
  let image: UIImage
  
  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.id == rhs.id && lhs.image == rhs.image
  }
}

