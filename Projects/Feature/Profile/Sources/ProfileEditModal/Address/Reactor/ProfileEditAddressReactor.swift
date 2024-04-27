//
//  ProfileEditAddressReactor.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/4/24.
//

import ReactorKit
import SharedDesignSystem
import DomainUser
import DomainUserInterface
import DomainCommon

final class ProfileEditAddressReactor: Reactor {
  private let getUserDataUseCase: GetUserProfileUseCase
  private let saveSaveAddressUseCase: SaveAddressUseCase
  
  enum Action {
    case selectAddress(AddressCase)
    case tabChangeButton
  }
  
  enum Mutation {
    case setSelectedAddress(AddressCase)

    case isLoading(Bool)
    case setIsChangeButtonEnabled(Bool)
    case setIsSaveSuccess
    case setError(ErrorType?)
  }
  
  struct State {
    let addressArray: [RadioSegmentItem]
    let initialAddress: AddressCase?
    var selectedAddress: AddressCase?
    
    var isLoading: Bool = false
    var isChangeButtonEnabled = false
    var isSaveSuccess: Bool = false
    var errorState: ErrorType? = nil
  }
  
  var initialState: State
  
  public init(saveSaveAddressUseCase: SaveAddressUseCase, getUserDataUseCase: GetUserProfileUseCase) {
    self.getUserDataUseCase = getUserDataUseCase
    self.saveSaveAddressUseCase = saveSaveAddressUseCase
    
    let profileData = getUserDataUseCase.execute()
    var addressCase: AddressCase? = nil
    if let address = profileData.address {
      addressCase = AddressCase.getAddressCase(name: address)
    }
    self.initialState = State(
      addressArray: AddressCase.allCases.enumerated().map { index, name in
        return RadioSegmentItem(id: index, title: name.stringKR)
      },
      initialAddress: addressCase,
      selectedAddress: addressCase
    )
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

extension ProfileEditAddressReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tabChangeButton:
      if currentState.initialAddress == currentState.selectedAddress {
        return .just(.setIsSaveSuccess)
      } else {
        return .concat([
          .just(.isLoading(true)),
          self.saveSaveAddressUseCase.execute(address: currentState.selectedAddress!.stringKR)
            .asObservable()
            .map { _ in .setIsSaveSuccess }
            .catch { error -> Observable<Mutation> in
              return error.toMutation()
            },
          .just(.isLoading(false))
        ])
      }
      
    case .selectAddress(let address):
      return .concat([
        .just(.setSelectedAddress(address)),
        .just(.setIsChangeButtonEnabled(true))
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
    case .setSelectedAddress(let address):
      newState.selectedAddress = address
      if newState.errorState != nil {
        newState.errorState = nil
      }
    case .setIsChangeButtonEnabled(let bool):
      newState.isChangeButtonEnabled = bool
    case .setError(let error):
      newState.errorState = error
    }
    return newState
  }
}

extension Error {
  func toMutation() -> Observable<ProfileEditAddressReactor.Mutation> {
    let errorMutation: Observable<ProfileEditAddressReactor.Mutation> = {
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
