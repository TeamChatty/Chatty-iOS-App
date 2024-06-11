//
//  OnboardingPhoneAuthenticationReactor.swift
//  FeatureOnboarding
//
//  Created by walkerhilla on 1/5/24.
//

import UIKit
import RxSwift
import ReactorKit
import DomainAuthInterface
import DomainUserInterface
import DomainCommon
import Shared

public final class OnboardingPhoneAuthenticationReactor: Reactor {
  public let type: OnboardingAuthType
  
  private let sendVerificationCodeUseCase: SendVerificationCodeUseCase
  private let getDeviceIdUseCase: GetDeviceIdUseCase
  private let signUseCase: SignUseCase
  private let getUserProfileUseCase: GetUserProfileUseCase
  
  public enum Action {
    case viewDidAppear
    case phoneNumberEntered(String)
    case sendSMS
    case resendSMS
    case sendVerificationCode(String)
    case sendVerificationCodeWithout
  }
  
  public enum Mutation {
    case setSendSMSState(AsyncState<Void>)
    case setSendSMSButton(PhoneNumberValidationResult)
    case setPhoneNumber(String)
    case setVerificationCode(String)
    case setSendVerificationCodeState(AsyncState<Void>)
    case setError(ErrorType?)
    case setSendCount(Int)
    case setTestAccessVerificationCode(String)
    case setIsViewDidAppear(Bool)
  }
  
  public struct State {
    var phoneNumber: String = ""
    var isSendSMSButtonEnabled: Bool = false
    var sendSMSState: AsyncState<Void> = .idle
    var sendVerificationCodeState: AsyncState<Void> = .idle
    var verificationCode: String = ""
    var testVerificationCode: String? = nil
    var isViewDidAppear: Bool = false
    
    var sendCount: Int = 0
    var errorState: ErrorType? = nil
  }
  
  public let initialState: State = State()
  
  public init(type: OnboardingAuthType, sendVerificationCodeUseCase: SendVerificationCodeUseCase, getDeviceIdUseCase: GetDeviceIdUseCase, signUseCase: SignUseCase, getUserProfileUseCase: GetUserProfileUseCase) {
    self.type = type
    self.sendVerificationCodeUseCase = sendVerificationCodeUseCase
    self.getDeviceIdUseCase = getDeviceIdUseCase
    self.signUseCase = signUseCase
    self.getUserProfileUseCase = getUserProfileUseCase
  }
  
  var isTestAccess: Bool {
    for i in 1...3 {
      let testNumber = "0100000000\(i)"
      if testNumber == self.currentState.phoneNumber {
        return true
      }
    }
    return false
  }
}

extension OnboardingPhoneAuthenticationReactor {
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .phoneNumberEntered(let phoneNumber):
      let isPhoneNumberValid = isPhoneNumberValid(phoneNumber)
      return .from([.setSendSMSButton(isPhoneNumberValid), .setPhoneNumber(phoneNumber)])
    case .sendSMS:
      return Observable.concat([
        .just(.setSendSMSState(.loading)),
        self.sendVerificationCodeUseCase.execute(mobileNumber: self.currentState.phoneNumber)
          .asObservable()
          .flatMap { count -> Observable<Mutation> in
            return .concat([
              .just(.setSendSMSState(.success(.sendSms))),
              .just(.setSendCount(count.limitNumber)),
              .just(.setTestAccessVerificationCode(count.authNumber))
            ])
          }
          .catch { error -> Observable<Mutation> in
            return error.toMutation()
          },
        .just(.setSendSMSState(.idle))
      ])
    case .resendSMS:
      return .concat([
        self.sendVerificationCodeUseCase.execute(mobileNumber: self.currentState.phoneNumber)
          .asObservable()
          .flatMap { count -> Observable<Mutation> in
            return .concat([
              .just(.setIsViewDidAppear(false)),
              .just(.setSendCount(count.limitNumber)),
              .just(.setTestAccessVerificationCode(count.authNumber)),
              .just(.setIsViewDidAppear(true))
            ])
          }
      ])
    case .sendVerificationCode(let code):
      switch type {
      case .signIn:
        return processLogin(mobileNumber: self.currentState.phoneNumber, authenticationNumber: code)
      case .signUp:
        return Observable.concat([
          signUseCase.requestJoin(mobileNumber: self.currentState.phoneNumber, authenticationNumber: code)
            .asObservable()
            .map { _ in .setSendVerificationCodeState(.success(.signUp)) }
            .catch { error -> Observable<Mutation> in
              return error.toMutation()
            },
          .just(.setSendVerificationCodeState(.idle)),
          .just(.setVerificationCode(code))
        ])
      }
    case .sendVerificationCodeWithout:
      return processLogin(mobileNumber: self.currentState.phoneNumber, authenticationNumber: currentState.verificationCode)
    case .viewDidAppear:
      return .concat([
        .just(.setIsViewDidAppear(false)),
        .just(.setIsViewDidAppear(true))
      ])
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setSendSMSState(let state):
      newState.sendSMSState = state
    case .setSendSMSButton(let result):
      newState.isSendSMSButtonEnabled = result == .valid ? true : false
    case .setPhoneNumber(let phoneNumber):
      newState.phoneNumber = phoneNumber
    case .setSendVerificationCodeState(let state):
      newState.sendVerificationCodeState = state
    case .setError(let state):
      newState.errorState = state
    case .setVerificationCode(let code):
      newState.verificationCode = code
    case .setSendCount(let count):
      newState.sendCount = count
    case .setTestAccessVerificationCode(let verificationCode):
      if isTestAccess {
        newState.testVerificationCode = verificationCode
      }
    case .setIsViewDidAppear(let bool):
      newState.isViewDidAppear = bool
    }
    return newState
  }
  
  private func isPhoneNumberValid(_ phoneNumberStr: String) -> PhoneNumberValidationResult {
    guard let _ = Int(phoneNumberStr) else { return .notANumber }
    guard phoneNumberStr.count == 11 else { return .lengthNotValid }
    return .valid
  }
  
  func processLogin(mobileNumber: String, authenticationNumber: String) -> Observable<Mutation> {
    return Observable.concat([
      signUseCase.requestLogin(mobileNumber: mobileNumber, authenticationNumber: authenticationNumber)
        .asObservable()
        .flatMap { loginResponse -> Observable<Mutation> in
          self.getUserProfileUseCase.executeSingle()
            .asObservable()
            .flatMap { userData -> Observable<Mutation> in
              if userData.authority == .user {
                return .just(.setSendVerificationCodeState(.success(.signIn)))
              } else {
                return .concat([
                  .just(.setError(.profileNotCompleted)),
                  .just(.setError(nil))
                ])
              }
            }
        }
        .catch { error -> Observable<Mutation> in
          return error.toMutation()
        },
      .just(.setSendVerificationCodeState(.idle))
    ])
  }
  
  public enum PhoneNumberValidationResult {
    case valid
    case notANumber
    case lengthNotValid
  }
  
  public enum AsyncState<T>: Equatable {
    case idle
    case loading
    case success(NetworkAction)
  }
  
  public enum NetworkAction {
    case sendSms
    case signUp
    case signIn
  }
  
  public enum ErrorType: Error {
    case invalidPhoneNumber
    case invalidVerificationCode
    case mismatchedDeviceId
    case alreadyExistUser
    case profileNotCompleted
    case smsFailed
    case unknownError
    case phoneAuthentificationDailyRequestLimitExceeded
  }
}

extension Error {
  func toMutation() -> Observable<OnboardingPhoneAuthenticationReactor.Mutation> {
    let errorMutation: Observable<OnboardingPhoneAuthenticationReactor.Mutation> = {
      guard let error = self as? NetworkError else { return .just(.setError(.unknownError))}
      switch error.errorCase {
      case .E005NaverSMSFailed:
        return .just(.setError(.smsFailed))
      case .E007SMSAuthenticationFailed:
        return .just(.setError(.invalidVerificationCode))
      case .E008AlreadyExistUser:
        return .just(.setError(.alreadyExistUser))
      case .E023MismatchedAccountAndDeviceId:
        return .just(.setError(.mismatchedDeviceId))
      case .E036PhoneAuthentificationDailyRequestLimitExceeded:
        return .just(.setError(.phoneAuthentificationDailyRequestLimitExceeded))
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
