//
//  UIImage+Extension.swift
//  SharedUtil
//
//  Created by 윤지호 on 2/23/24.
//

import UIKit

extension UIImage {
  public func toProfileRequestData() -> Data {
    guard let imageData = self.jpegData(compressionQuality: 0.5) else {
      return Data()
    }
    return imageData
  }
}
