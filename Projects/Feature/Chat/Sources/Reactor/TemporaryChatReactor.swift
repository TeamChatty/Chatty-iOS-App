//
//  TemporaryChatReactor.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 26.04.2024.
//

import Foundation
import RxSwift
import ReactorKit

public final class TemporaryChatReactor: Reactor {
  public enum Action {
    case runTimer(Date)
    case stopTimer
    case timerTick
  }
  
  public enum Mutation {
    case setCreateTime(Date)
    case setTimer(TimeInterval)
    case tick(TimeInterval)
  }
  
  public struct State {
    public var createdTime: Date?
    public var timeInterval : TimeInterval = 600
    public var timeString: String = "-- : --"
    public var chatRoomStatus: ChatRoomStatus = .withinTenMinutes
  }
  
  public var initialState: State = .init()
  private var timer: Timer?
  
  deinit {
    print("Deinit - TemporaryChatReactor")
    timer?.invalidate()
  }
  
  public enum ChatRoomStatus {
    case withinTenMinutes
    case withinOneMinute
    case timeExpired
  }
  
}

extension TemporaryChatReactor {
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .runTimer(let date):
      let now = Date()
      let timezone = TimeZone.autoupdatingCurrent
      let secondsFromGMT = timezone.secondsFromGMT(for: now)
      let localizedDate = now.addingTimeInterval(TimeInterval(secondsFromGMT))
      let timeInterval = date.timeIntervalSince(localizedDate)
      startTimer(from: date)
      return .concat([
        .just(.setCreateTime(date)),
        .just(.setTimer(timeInterval))
      ])
    case .timerTick:
      guard let createdDate = currentState.createdTime else {
        return .empty()
      }
      let now = Date()
      let timezone = TimeZone.autoupdatingCurrent
      let secondsFromGMT = timezone.secondsFromGMT(for: now)
      let localizedDate = now.addingTimeInterval(TimeInterval(secondsFromGMT))
      let timeInterval = createdDate.timeIntervalSince(localizedDate)
      return .just(.tick(timeInterval))
    case .stopTimer:
      timer?.invalidate()
      return .never()
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setTimer(let timeInterval):
      newState.timeInterval = currentState.timeInterval - abs(timeInterval)
    case .tick(let newTimeInterval):
      let newTimeInterval = 600 - abs(newTimeInterval)
      let newTimeString = timeIntervalToString(newTimeInterval)
      newState.timeInterval = newTimeInterval
      newState.timeString = newTimeString
      
      if newTimeInterval <= 0 {
        newState.chatRoomStatus = .timeExpired
        stopTimer()
      }
      
      if newTimeInterval == 60  {
        newState.chatRoomStatus = .withinOneMinute
      }
    case .setCreateTime(let date):
      newState.createdTime = date
    }
    return newState
  }
  
  private func startTimer(from date: Date) {
    stopTimer()
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
      self?.action.onNext(.timerTick)
    }
  }
  
  private func stopTimer() {
    timer?.invalidate()
  }
  
  private func timeIntervalToString(_ timeInterval: TimeInterval) -> String {
    let minutes = Int(timeInterval) / 60
    let seconds = Int(timeInterval) % 60
    return String(format: "%02d : %02d", minutes, seconds)
  }
}
