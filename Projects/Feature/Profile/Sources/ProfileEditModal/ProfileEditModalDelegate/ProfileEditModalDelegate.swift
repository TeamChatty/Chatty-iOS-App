//
//  ProfileEditModalDelegate.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/4/24.
//

import Foundation

protocol ProfileEditModalDelegate: AnyObject {
  func dismissModal()
  func successEdit(editType: ProfileEditType)
}
