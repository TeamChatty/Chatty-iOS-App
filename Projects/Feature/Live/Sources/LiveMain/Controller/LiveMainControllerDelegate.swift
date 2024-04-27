//
//  LiveMainControllerDelegate.swift
//  FeatureLive
//
//  Created by 윤지호 on 2/29/24.
//

import Foundation
import DomainLiveInterface
import FeatureChatInterface

protocol LiveMainControllerDelegate: AnyObject {
  func pushToMatchingView()
  func pushToCandyStore()
  func pushToMembershipView()
  func presentEditGenderConditionModal(_ matchState: MatchConditionState)
  func presentEditAgeConditionModal(_ matchState: MatchConditionState)
  func presentMatchModeModal(_ matchState: MatchConditionState)
}
