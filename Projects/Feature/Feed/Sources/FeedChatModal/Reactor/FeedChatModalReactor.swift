//
//  FeedChatModalReactor.swift
//  FeatureFeed
//
//  Created by 윤지호 on 5/20/24.
//


import ReactorKit
import DomainUser
import DomainUserInterface
import DomainChatInterface
import DomainChat
import DomainCommon

final class FeedChatModalReactor: Reactor {
  private let getSomeoneProfileUseCase: GetSomeoneProfileUseCase
  private let creatChatRoomUseCase: DefaultCreatChatRoomUseCase
  
  enum Action {
    case viewDidLoad
    case tabChangeButton
  }
  
  enum Mutation {
    case setSomeoneProfile(SomeoneProfile)
    case setCreatedChatRoom(ChatRoom)
    
    case isLoading(Bool)
    case setError(ErrorType?)
  }
  
  struct State {
    let someoneId: Int
    
    var someoneProfile: SomeoneProfile? = nil
    var createdChatRoom: ChatRoom? = nil
    var isSuccessCreatedChatRoom: Bool = false
    
    var isLoading: Bool = false
    var errorState: ErrorType? = nil
  }
  
  var initialState: State
  
  public init(getSomeoneProfileUseCase: GetSomeoneProfileUseCase, creatChatRoomUseCase: DefaultCreatChatRoomUseCase, someoneId: Int) {
    self.getSomeoneProfileUseCase = getSomeoneProfileUseCase
    self.creatChatRoomUseCase = creatChatRoomUseCase
    self.initialState = State(someoneId: someoneId)
  }
  
  public enum ErrorType: Error {
    case unknownError
    case alreadyExistChatRoom
    
    var description: String {
      switch self {
      case .alreadyExistChatRoom:
            return "이미 채팅방이 개설된 유저입니다."
      case .unknownError:
        return "문제가 생겼어요. 다시 시도해주세요."
      }
    }
  }
}

extension FeedChatModalReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return .concat([
        .just(.isLoading(true)),
        getSomeoneProfileUseCase.execute(userId: initialState.someoneId)
          .asObservable()
          .map { .setSomeoneProfile($0) },
        .just(.isLoading(false))
      ])
    case .tabChangeButton:
      return .concat([
        .just(.isLoading(true)),
        creatChatRoomUseCase.execute(receiverId: initialState.someoneId)
          .map { .setCreatedChatRoom($0) }
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
    case .setSomeoneProfile(let someoneProfile):
      newState.someoneProfile = someoneProfile
   
    case .setCreatedChatRoom(let chatRoom):
      newState.createdChatRoom = chatRoom
      newState.isSuccessCreatedChatRoom = true
      
    case .isLoading(let bool):
      newState.isLoading = bool
    case .setError(let error):
      newState.errorState = error
    
    }
    return newState
  }
}

extension Error {
  func toMutation() -> Observable<FeedChatModalReactor.Mutation> {
    let errorMutation: Observable<FeedChatModalReactor.Mutation> = {
      guard let error = self as? NetworkError else {
        return .just(.setError(.unknownError))
      }
      switch error.errorCase {
      case.E012AlreadyExistChatRoom:
        return .just(.setError(.alreadyExistChatRoom))
      default:
        return .just(.setError(.unknownError))
      }
    }()
    
    return Observable.concat([
      errorMutation
    ])
  }
}


