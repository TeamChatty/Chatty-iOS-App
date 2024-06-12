//
//  LiveEditConditionModalReactor.swift
//  FeatureLive
//
//  Created by 윤지호 on 2/29/24.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit

import DomainCommon
import DomainLiveInterface
import DomainChat

public final class LiveEditConditionModalReactor: Reactor {
  private let matchConditionUseCase: MatchConditionUseCase

  private let connectMatchUserCase: ConnectMatchUseCase
  private var socketResultSubject: PublishSubject<MatchSocketResult> = .init()
  private var isSocketOpenedSubject: PublishSubject<Void> = .init()
  private let getChatRoomUseCase: DefaultGetChatRoomUseCase
  
  private let disposeBag = DisposeBag()
  
  public enum Action {
    case tabSaveButton
    // LiveEditGenderConditionModal
    case selectGender(MatchGender)
    
    // LiveEditAgeConditionModal
    case selectAge(MatchAgeRange)
    case resetAge
    
    // LiveSelectMatchMode
    case toggleProfileAuthenticationConnection(Bool)
    case startMatching(MatchMode)
    
    // LiveMatchingController
    case matchingStart
    case matchSocketOpened
    case matchingSuccess(MatchSocketResult)
    case getError(Error)
    case matchingExit
  }
  
  public enum Mutation {
    case setConditionState
    case setGenderCondition(MatchGender)
    case setAgeCondition(MatchAgeRange)
    case toggleProfileAuthenticationConnection(Bool)
    case startMatching(MatchMode)
    case setMathcingState(MatchingState)
    case setError(ErrorType?)
  }
  
  public struct State {
    var matchConditionState: MatchConditionState
    var matchingState: MatchingState = .ready
    var errorState: ErrorType? = nil
    
    var matchMode: MatchMode = .nomalMode
    
    var isSuccessSaved: Bool = false
    var isMatchStarted: Bool = false
  }
  
  public var initialState: State
  
  public init(matchState: MatchConditionState, matchConditionUseCase: MatchConditionUseCase, connectMatchUserCase: ConnectMatchUseCase, getChatRoomUseCase: DefaultGetChatRoomUseCase) {
    self.initialState = State(matchConditionState: matchState)
    self.matchConditionUseCase = matchConditionUseCase
    self.connectMatchUserCase = connectMatchUserCase
    self.getChatRoomUseCase = getChatRoomUseCase
  }
}

extension LiveEditConditionModalReactor {
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tabSaveButton:
      /// Match Condition - User Defaults에 저장 저장
      _ = matchConditionUseCase.saveCondition(state: currentState.matchConditionState)
      return .just(.setConditionState)
    case .selectGender(let matchGender):
      return .just(.setGenderCondition(matchGender))
    case .selectAge(let range):
      return .just(.setAgeCondition(range))
    case .resetAge:
      let data = matchConditionUseCase.getCondition().ageRange
      return .just(.setAgeCondition(data))
    case .toggleProfileAuthenticationConnection(let bool):
      return .just(.toggleProfileAuthenticationConnection(bool))
    case .startMatching(let matchMode):
      _ = matchConditionUseCase.saveCondition(state: currentState.matchConditionState)
      return .just(.startMatching(matchMode))
      
      /// 1. 소켓 연결 확인 Subject
    case .matchingStart:
      self.isSocketOpenedSubject = connectMatchUserCase.getSocketState()
      bindSocketOpened()
      return .just(.setMathcingState(.ready))
      /// 2. 소켓 연결이 확인되면 bind()
    case .matchSocketOpened:
      self.socketResultSubject = connectMatchUserCase.getSocket()
      bindSocket()
      /// 3. 연결된 소켓으로 sendData
      return connectMatchUserCase.sendData(
        minAge: currentState.matchConditionState.ageRange.startAge,
        maxAge: currentState.matchConditionState.ageRange.endAge,
        gender: currentState.matchConditionState.gender.requestString,
        scope: nil,
        category: "category",
        blueCheck: currentState.matchConditionState.isProfileAuthenticationConnection
      )
      .asObservable()
      .map { _ -> Mutation in
        return .setMathcingState(.matching)
      }
      .catch { error -> Observable<Mutation> in
        return error.toMutation()
      }
    case .matchingSuccess(let result):
      return getChatRoomUseCase.exectue(roomId: result.roomId)
        .asObservable()
        .flatMap { room -> Observable<Mutation> in
          return .just(.setMathcingState(.successMatching(room)))
        }
    case .getError(let error):
      return error.toMutation()
    case .matchingExit:
      connectMatchUserCase.disconnectSocket()
      return .never()
    }
  }
  
  private func bindSocketOpened() {
    isSocketOpenedSubject.subscribe(
      with: self,
      onNext: { reactor, _ in
        reactor.action.onNext(.matchSocketOpened)
      },
      onError: { reactor, error in
        print("error - \(error)")
        reactor.action.onNext(.getError(error))
      })
  .disposed(by: disposeBag)
  }
  
  private func bindSocket() {
    socketResultSubject.subscribe(
        with: self,
        onNext: { reactor, matchRes in
          reactor.action.onNext(.matchingSuccess(matchRes))
        },
        onError: { reactor, error in
          reactor.action.onNext(.getError(error))
        })
    .disposed(by: disposeBag)
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setConditionState:
      newState.isSuccessSaved = true
    case .setGenderCondition(let matchGender):
      newState.matchConditionState.gender = matchGender
    case .setAgeCondition(let range):
      newState.matchConditionState.ageRange.startAge = range.startAge
      newState.matchConditionState.ageRange.endAge = range.endAge
    case .toggleProfileAuthenticationConnection(let bool):
      newState.matchConditionState.isProfileAuthenticationConnection = bool
    case .startMatching(let matchMode):
      newState.matchMode = matchMode
      newState.isMatchStarted = true
    case .setMathcingState(let matchingState):
      newState.matchingState = matchingState
    case .setError(let error):
      newState.errorState = error
    }
    return newState
  }
  
  public enum ErrorType: Error {
    case socketDisconnected
    case socketTokenExpiration
    case socketSetupError
    case unknownError
  }
}

extension Error {
  func toMutation() -> Observable<LiveEditConditionModalReactor.Mutation> {
    let errorMutation: Observable<LiveEditConditionModalReactor.Mutation> = {
      if let error = self as? LiveSocketError {
        switch error {
        case .disconnected:
          return .just(.setError(.socketDisconnected))
        case .accessTokenExpiration:
          return .just(.setError(.socketTokenExpiration))
        case .setupError:
          return .just(.setError(.socketSetupError))
        default:
          return .just(.setError(.unknownError))
        }
      }
      
      if let error = self as? NetworkError {
        switch error.errorCase {
        default:
          return .just(.setError(.unknownError))
        }
      }
      
      return .just(.setError(.unknownError))
    }()
    
    return Observable.concat([
      errorMutation,
      .just(.setError(nil))
    ])
  }
}
