//
//  ProfileEditMBTIReactor.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/5/24.
//

import ReactorKit
import DomainUser
import DomainUserInterface
import DomainCommon


final class ProfileEditInterestsReactor: Reactor {
  private let getUserDataUseCase: GetUserProfileUseCase
  private let getAllInterestsUseCase: GetAllInterestsUseCase
  private let saveInterestsUseCase: SaveInterestsUseCase
  
  enum Action {
    case viewDidLoad
    case tabChangeButton
    case tabTag(Interest)
  }
  
  enum Mutation {
    case setInterestsTags([Interest])
    case tabTag(Interest)

    case isLoading(Bool)
    case setIsChangeButtonEnabled(Bool)
    case setIsSaveSuccess
    case setError(ErrorType?)
  }
  
  struct State {
    var interest: [Interest]
    var Allinterests: [Interest] = []
    
    var isLoading: Bool = false
    var isChangeButtonEnabled = false
    var isSaveSuccess: Bool = false
    var errorState: ErrorType? = nil
  }
  
  var initialState: State
  
  public init(getAllInterestsUseCase: GetAllInterestsUseCase, saveInterestsUseCase: SaveInterestsUseCase, getUserDataUseCase: GetUserProfileUseCase) {
    self.getAllInterestsUseCase = getAllInterestsUseCase
    self.getUserDataUseCase = getUserDataUseCase
    self.saveInterestsUseCase = saveInterestsUseCase
    
    self.initialState = State(interest: getUserDataUseCase.execute().interests)
  }
  
  public enum ErrorType: Error {
    case unknownError
    
    var description: String {
      switch self {
      case .unknownError:
        return "문제가 생겼어요. 다시 시도해주세요."
      }
    }
  }
}

extension ProfileEditInterestsReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return .concat([
        .just(.isLoading(true)),
        getAllInterestsUseCase.execute()
          .asObservable()
          .map { interest in
            let interests = interest.interests.sorted(by: { $0.id < $1.id })
            return .setInterestsTags(interests)
          }
          .catch { error -> Observable<Mutation> in
            return error.toMutation()
          },
        .just(.isLoading(false))
      ])
    case .tabTag(let tag):
      return .just(.tabTag(tag))
    case .tabChangeButton:
      return .concat([
        .just(.isLoading(true)),
        self.saveInterestsUseCase.execute(interests: currentState.interest)
          .asObservable()
          .map { _ in .setIsSaveSuccess }
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
    
    case .isLoading(let bool):
      newState.isLoading = bool
    case .setIsSaveSuccess:
      newState.isSaveSuccess = true
    case .setIsChangeButtonEnabled(let bool):
      newState.isChangeButtonEnabled = bool
    case .setError(let error):
      newState.errorState = error
    case .setInterestsTags(let tags):
      newState.Allinterests = tags
    case .tabTag(let tag):
      if let duplicatedIndex = newState.interest.firstIndex(where: { $0 == tag }) {
        newState.interest.remove(at: duplicatedIndex)
      } else {
        if newState.interest.count < 3 {
          newState.interest.append(tag)
        }
      }
      newState.isChangeButtonEnabled = newState.interest.count > 2
    }
    return newState
  }
}

extension Error {
  func toMutation() -> Observable<ProfileEditInterestsReactor.Mutation> {
    let errorMutation: Observable<ProfileEditInterestsReactor.Mutation> = {
      guard let error = self as? NetworkError else {
        return .just(.setError(.unknownError))
      }
      switch error.errorCase {
      default:
        return .just(.setError(.unknownError))
      }
    }()
    
    return Observable.concat([
      errorMutation
    ])
  }
}
