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
    case timerTick
  }
  
  public enum Mutation {
    case setTimer(TimeInterval)
    case tick
  }
  
  public struct State {
    var timeInterval: TimeInterval?
  }
  
  public var initialState: State = .init()
  private var timer: Timer?
  
  deinit {
    timer?.invalidate()
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
      print("채팅방 생성된 날짜: \(date)")
      print("지금 \(localizedDate)")
      let timeInterval = date.timeIntervalSince(localizedDate)
      print("채팅방 생성된지 \(timeInterval)")
      
      return .just(.setTimer(timeInterval))
    case .timerTick:
      return .just(.tick)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setTimer(let timeInterval):
      newState.timeInterval = timeInterval
    case .tick:
      if let currentTimeInterval = newState.timeInterval {
        newState.timeInterval = currentTimeInterval - 1
      }
      print(newState.timeInterval)
    }
    return newState
  }
  
  public func startTimer(from date: Date) {
    self.action.onNext(.runTimer(date))
    
    timer?.invalidate()
    
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
      print("타이머는 돌아가냐?")
      self?.action.onNext(.timerTick)
    }
  }
  
  public func stopTimer() {
    print("멈췄다 타이머~")
    timer?.invalidate()
  }
}
