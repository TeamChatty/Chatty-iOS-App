//
//  LiveSocketRepository.swift
//  DataRepositoryInterface
//
//  Created by 윤지호 on 3/4/24.
//

import Foundation
import DataNetworkInterface
import DataRepositoryInterface
import DomainLiveInterface

import RxSwift

public final class DefaultLiveSocketRepository: LiveSocketRepository {
  
  private let liveWebSocketService: any LiveSocketService
  
  public init(liveWebSocketService: any LiveSocketService) {
    self.liveWebSocketService = liveWebSocketService
  }
  
  public func openSocket() -> PublishSubject<Void> {
    return liveWebSocketService.openSocket()
  }
  
  public func connectSocket() -> PublishSubject<MatchSocketResult> {
    return liveWebSocketService.connectSocket()
  }
  
  public func sendRequest(_ match: MatchResult) {
    let request = MatchSocketRequestDTO(matchCondition: match)
    liveWebSocketService.sendRequest(reqeust: request)
  }
  
  public func disconnectSocket() {
    liveWebSocketService.disconnectSocket()
  }
}
