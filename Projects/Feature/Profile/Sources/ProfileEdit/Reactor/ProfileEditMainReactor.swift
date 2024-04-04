//
//  ProfileEditMainReactor.swift
//  FeatureProfileInterface
//
//  Created by 윤지호 on 3/21/24.
//

import ReactorKit
import DomainUser
import DomainUserInterface
import DomainCommon

final class ProfileEditMainReactor: Reactor {
  private let getUserDataUseCase: GetUserDataUseCase
  
  enum Action {
    case changePage(Int)
    case editSuccessed(ProfileEditType)
  }
  
  enum Mutation {
    case setPage(Int)
    case setProfileData(UserProfile)
    case setIsShowingToastView(Bool)
  }
  
  struct State {
    var profileData: UserProfile
    var pageIndex: Int = 0
    var isShowingToastView: Bool = false
  }
  
  var initialState: State
  
  public init(getUserDataUseCase: GetUserDataUseCase) {
    self.getUserDataUseCase = getUserDataUseCase
    self.initialState = State(profileData: getUserDataUseCase.execute())
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
    }
    return newState
  }
}
