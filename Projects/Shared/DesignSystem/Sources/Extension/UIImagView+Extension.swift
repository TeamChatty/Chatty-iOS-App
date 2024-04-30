//
//  UIImagView+Extension.swift
//  SharedDesignSystem
//
//  Created by 윤지호 on 3/25/24.
//

import UIKit
import Kingfisher

extension UIImageView {
  public func setImageKF(urlString: String?) {
    self.kf.indicatorType = .activity
    guard let urlString,
          let url = URL(string: urlString) else {
      return
    }
    
    self.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
  }
  
  public func setProfileImageKF(urlString: String?, gender: CommonProfile, scale: CommonProfileScale) {
    self.kf.indicatorType = .activity
    guard let urlString,
          let url = URL(string: urlString) else {
      self.image = gender.getProfileImage(scale: scale)
      return
    }
    
    self.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil) { result in
      switch result {
      case .failure(_):
        self.image = gender.getProfileImage(scale: scale)
      case .success(let result):
        self.image = result.image
      }
    }

  }
}
