//
//  ProfileEditMainReactor.swift
//  FeatureProfileInterface
//
//  Created by 윤지호 on 3/21/24.
//

import UIKit
import ReactorKit
import DomainUser
import DomainUserInterface
import DomainCommon

final class ProfileEditMainReactor: Reactor {
  private let getUserDataUseCase: GetUserDataUseCase
  
  enum Action {
    case changePage(Int)
    case editSuccessed(ProfileEditType)
    case selectImage(UIImage)
  }
  
  enum Mutation {
    case setPage(Int)
    case setProfileData(UserProfile)
    case setIsShowingToastView(Bool)
    case isLoading(Bool)
    case setError(ErrorType?)
  }
  
  struct State {
    var profileData: UserProfile
    var pageIndex: Int = 0
    var isShowingToastView: Bool = false
    
    var isLoading: Bool = false
    var errorState: ErrorType? = nil
  }
  
  var initialState: State
  
  public init(getUserDataUseCase: GetUserDataUseCase) {
    self.getUserDataUseCase = getUserDataUseCase
    self.initialState = State(profileData: getUserDataUseCase.execute())
  }
  
  public enum ErrorType: Error {
    case unknownError
  }
}

extension ProfileEditMainReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .changePage(let index):
      return .just(.setPage(index))
    case .editSuccessed:
      let userProfile = self.getUserDataUseCase.execute()
      return .concat([
        .just(.setProfileData(userProfile)),
        .just(.setIsShowingToastView(true))
      ])
    case .selectImage(let image):
      return .concat([
        .just(.isLoading(true)),
        getUserDataUseCase.executeSingle()
          .asObservable()
          .map { .setProfileData($0) }
          .catch { error -> Observable<Mutation> in
            return error.toMutation()
          },
        .just(.isLoading(false))
      ])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setPage(let index):
      newState.pageIndex = index
    case .setProfileData(let profileData):
      newState.profileData = profileData
    case .setIsShowingToastView(let bool):
      newState.isShowingToastView = bool
    case .isLoading(let bool):
      newState.isLoading = bool
    case .setError(let error):
      newState.errorState = error
    }
    return newState
  }
}

extension Error {
  func toMutation() -> Observable<ProfileEditMainReactor.Mutation> {
    let errorMutation: Observable<ProfileEditMainReactor.Mutation> = {
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

