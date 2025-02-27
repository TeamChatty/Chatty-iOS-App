//
//  CoordinatorType.swift
//  Shared
//
//  Created by walkerhilla on 12/25/23.
//

import UIKit

public enum CoordinatorType {
  case app, tab
  case chat
  case live(LiveType)
  case onboarding(OnboardingType)
  case profile(ProfileType)
  case setting(SettingType)
  case feed(FeedType)
  case notification
}

public enum LiveType {
  case main
  case matching
}

public enum OnboardingType {
  case root
  case terms
  case auth(OnboardingAuthType)
  case newDeviceAccess(NewDeviceAccessType)
  case profileUpdate(OnboardingProfileType)
}

public enum OnboardingAuthType {
  case signIn
  case signUp
}

public enum OnboardingProfileType {
  case nickName, profiles
}

public enum NewDeviceAccessType {
  case accountOwnerCheck
  case accountSecurityQuestion
}

public enum ProfileType {
  case main
  case editMain
  case editType
}

public enum FeedType {
  case main
  case profile
  case detail
}

public enum SettingType {
  case main
  case changePhoneNumber
}
