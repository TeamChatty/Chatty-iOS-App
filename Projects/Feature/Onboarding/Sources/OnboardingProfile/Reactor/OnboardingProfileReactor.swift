//
//  OnboardingProfileViewModel.swift
//  FeatureOnboardingInterface
//
//  Created by 윤지호 on 12/31/23.
//

import UIKit
import RxSwift
import ReactorKit
import DomainUserInterface
import DomainCommon

public final class OnboardingProfileReactor: Reactor {
  private let saveProfileDataUseCase: SaveProfileDataUseCase
  private let getInterestsUseCase: GetAllInterestsUseCase
  
  /// 뷰에서 수행할 수 있는 사용자의 액션
  public enum Action {
    case viewDidLoad
    case toggleGender(Gender)
    case selectBirth(Date)
    case toggleMBTI(MBTISeletedState, Bool)
    case selectImage(UIImage)
    case tabImagePicker
    case tabTag(Interest)
    case tabContinueButton
    case didPushed
  }
  
  /// 화면의 상태가 변화하는 요인
  public enum Mutation {
    case inputedGender(Gender)
    case inputedBirth(Date)
    case toggleMBTI(MBTISeletedState, Bool)
    case inputedImage(UIImage)
    case tabImagePicker
    case setInterestsTags([Interest])
    case tabTag(Interest)
    case isSaveSuccess
    case didPushed
    case isLoading(Bool)
    case setError(ErrorType?)
  }
  
  /// 화면의 상태를 나타내는 구조체
  public struct State {
    var viewState: EditProfileType
    var profileData: ProfileState
    var isContinueEnabled: Bool = false
    var isPickingImage: Bool = false
    var isSuccessSave: Bool = false
    var Allinterests: [Interest] = []
    var isLoading: Bool = false
    var errorState: ErrorType? = nil
  }
  
  public var initialState: State
  
  init(saveProfileDataUseCase: SaveProfileDataUseCase, getInterestsUseCase: GetAllInterestsUseCase, profileType: EditProfileType, profileData: ProfileState) {
    self.saveProfileDataUseCase = saveProfileDataUseCase
    self.getInterestsUseCase = getInterestsUseCase
    let state: State = {
      var state = State(viewState: profileType, profileData: profileData)
      
      switch state.viewState {
      case .gender:
        state.isContinueEnabled = state.profileData.gender != .none
      case .birth:
        state.isContinueEnabled = state.profileData.birth != nil ? true : false
      case .profileImage:
        state.isContinueEnabled = state.profileData.porfileImage != nil
      case .interest:
        state.isContinueEnabled = state.profileData.interest.count > 2
      case .mbti:
        state.isContinueEnabled = state.profileData.mbti.didSeletedAll
      case .none:
        print("none")
      }
      return state
    }()
    self.initialState = state
  }
}

extension OnboardingProfileReactor {
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      if currentState.viewState == .interest {
        return .concat([
          .just(.isLoading(true)),
          getInterestsUseCase.execute()
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
      } else {
        return .just(.isLoading(false))
      }
    case .toggleGender(let gender):
      return .just(.inputedGender(gender))
    case .selectBirth(let date):
      return .just(.inputedBirth(date))
    case .selectImage(let image):
      return .just(.inputedImage(image))
    case .tabImagePicker:
      return .just(.tabImagePicker)
    case .tabTag(let tag):
      return .just(.tabTag(tag))
    case .didPushed:
      return .just(.didPushed)
    case .toggleMBTI(let mbti, let state):
      return .just(.toggleMBTI(mbti, state))
    case .tabContinueButton:
      switch currentState.viewState {
      case .gender, .birth, .profileImage, .interest, .none:
        return .just(.isSaveSuccess)
      case .mbti:
        let profileData = self.currentState.profileData
        return .concat([
          .just(.isLoading(true)),
          saveProfileDataUseCase.executeObs(
            gender: profileData.gender.requestString,
            birth: profileData.birth?.toStringYearMonthDay() ?? "",
            imageData: profileData.porfileImage?.toProfileRequestData() ?? nil,
            interests: profileData.interest,
            mbti: profileData.mbti.requestString
          )
          .map { _ in .isSaveSuccess }
            .catch { error -> Observable<Mutation> in
              return error.toMutation()
            },
          .just(.isLoading(false))
        ])
      }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .inputedGender(let gender):
      newState.profileData.gender = gender
      newState.isContinueEnabled = true
    case .inputedBirth(let date):
      if newState.profileData.birth == nil {
        newState.profileData.birth = Date()
      } else {
        newState.profileData.birth = date
        newState.isContinueEnabled = true
      }
    
    case .inputedImage(let image):
      newState.profileData.porfileImage = image
      newState.isContinueEnabled = true
    case .tabImagePicker:
      newState.isPickingImage = true
    case .toggleMBTI(let mbti, let state):
      newState.profileData.mbti.setMBTI(mbti: mbti, state: state)
      newState.isContinueEnabled = newState.profileData.mbti.didSeletedAll
    case .setInterestsTags(let tags):
      newState.Allinterests = tags
    case .tabTag(let tag):
      if let duplicatedIndex = newState.profileData.interest.firstIndex(where: { $0 == tag }) {
        newState.profileData.interest.remove(at: duplicatedIndex)
      } else {
        if newState.profileData.interest.count < 3 {
          newState.profileData.interest.append(tag)
        }
      }
      newState.isContinueEnabled = newState.profileData.interest.count > 2
    case .didPushed:
      newState.isSuccessSave = false
      newState.isPickingImage = false
    case .isLoading(let bool):
      newState.isLoading = bool
    case .isSaveSuccess:
      newState.isSuccessSave = true
    case .setError(let error):
      newState.errorState = error
    }
    return newState
  }
  
  public enum ErrorType: Error {
    case refreshTokenExpired
    case unknownError
  }
}

extension Error {
  func toMutation() -> Observable<OnboardingProfileReactor.Mutation> {
    let errorMutation: Observable<OnboardingProfileReactor.Mutation> = {
      guard let error = self as? NetworkError else {
        return .just(.setError(.unknownError))
      }
      switch error.errorCase {
      case .E009RefreshTokenExpired:
        return .just(.setError(.refreshTokenExpired))
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
