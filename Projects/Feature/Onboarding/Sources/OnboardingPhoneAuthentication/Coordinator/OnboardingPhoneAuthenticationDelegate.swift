//
//  OnboardingPhoneAuthenticationDelegate.swift
//  FeatureOnboardingInterface
//
//  Created by walkerhilla on 12/29/23.
//

import UIKit
import Shared

public protocol OnboardingPhoneAuthenticationDelegate: AnyObject {
  func pushToVerificationCodeEntryView(_ reactor: OnboardingPhoneAuthenticationReactor?)
  func pushToNickNameView()
  func pushToAccountAccess()
}
