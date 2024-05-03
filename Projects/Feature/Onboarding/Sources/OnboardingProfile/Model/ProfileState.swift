//
//  ProfileType.swift
//  FeatureOnboardingInterface
//
//  Created by 윤지호 on 12/31/23.
//

import UIKit
import Shared
import SharedUtil
import DomainUserInterface

public struct ProfileState {
  var nickName: String
  var gender: Gender
  var porfileImage: UIImage? = nil
  var birth: Date? = nil
  var interest: [Interest]
  var mbti: MBTI
  
  init(nickName: String, gender: Gender, porfileImage: UIImage? = nil, birth: Date? = nil, interest: [Interest], mbti: MBTI) {
    self.nickName = nickName
    self.gender = gender
    self.porfileImage = porfileImage
    self.birth = birth
    self.interest = interest
    self.mbti = mbti
  }
}
