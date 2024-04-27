//
//  MatchingState.swift
//  FeatureLive
//
//  Created by 윤지호 on 3/1/24.
//

import Foundation
import DomainLiveInterface
import DomainChatInterface

public enum MatchingState {
  case stop
  case ready
  case matching
  case successMatching(ChatRoom)
  
  var stateText: String {
    switch self {
    case .stop:
      return "재시도 해주세요"
    case .ready:
      return "준비 중"
    case .matching:
      return "친구 찾는 중"
    case .successMatching:
      return "매칭 성공"
    }
  }
}
