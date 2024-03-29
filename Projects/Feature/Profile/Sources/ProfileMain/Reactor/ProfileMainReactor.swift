//
//  ProfileMainReactor.swift
//  FeatureProfileInterface
//
//  Created by 윤지호 on 3/17/24.
//

import ReactorKit

import DomainUser
import DomainUserInterface
import DomainCommon

final class ProfileMainReactor: Reactor {
  private let getUserDataUseCase: GetUserDataUseCase
  
  enum Action {
    case viewWillAppear
  }
  
  enum Mutation {
    case setProfileData(UserProfile)
    case setLoading(Bool)
    case setError(ErrorType?)
  }
  
  struct State {
    var profileData: UserProfile = UserProfile(nickname: "jiho", mobileNumber: "01077777777", birth: "2000-11-14", gender: .male, mbti: "INTP", authority: .user, address: nil, imageData: nil, interests: [], job: nil, introduce: nil, blueCheck: false)
    var candyCount: Int = 10
    var ticketCount: Int = 10
    
    var isLoading: Bool = false
    var errorState: ErrorType? = nil
  }
  
  var inputFinishPercent: Double {
    let fullCount: Double = 13
    var emptyCount: Double = 0
    if self.currentState.profileData.mbti == nil {
      emptyCount += 1
    }
    if self.currentState.profileData.authority == nil {
      emptyCount += 1
    }
    if self.currentState.profileData.address == nil {
      emptyCount += 1
    }
    if self.currentState.profileData.imageUrl == nil {
      emptyCount += 1
    }
    if self.currentState.profileData.interests.count < 3 {
      emptyCount += 1
    }
    if self.currentState.profileData.job == nil {
      emptyCount += 1
    }
    if self.currentState.profileData.introduce == nil {
      emptyCount += 1
    }
    return 100 / fullCount * (fullCount - emptyCount)
  }
  
  var initialState: State = State()
  
  public init(getUserDataUseCase: GetUserDataUseCase) {
    self.getUserDataUseCase = getUserDataUseCase
  }
}

extension ProfileMainReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewWillAppear:
      return .concat([
        .just(.setLoading(true)),
        getUserDataUseCase.executeSingle().asObservable()
          .map { userData in .setProfileData(userData as! UserProfile) }
          .catch { error -> Observable<Mutation> in
            return error.toMutation()
          },
        .just(.setLoading(false))
      ])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setLoading(let bool):
      newState.isLoading = bool
    case .setProfileData(let userData):
      newState.profileData = userData
    case .setError(let errorState):
      newState.errorState = errorState
    }
    
    return newState
  }
  
  public enum ErrorType: Error {
    case duplicatedNickname
    case unknownError
  }
}

extension Error {
  func toMutation() -> Observable<ProfileMainReactor.Mutation> {
    let errorMutation: Observable<ProfileMainReactor.Mutation> = {
      guard let error = self as? NetworkError else {
        return .just(.setError(.unknownError))
      }
      switch error.errorCase {
      default:
        return .just(.setError(.unknownError))
      }
    }()
    
    return Observable.concat([
      errorMutation,
      .just(.setError(nil))
    ])
  }
}
