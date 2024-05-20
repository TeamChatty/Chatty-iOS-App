//
//  LiveCoordinator.swift
//  FeatureLive
//
//  Created by walkerhilla on 12/26/23.
//

import UIKit
import Shared
import SharedDesignSystem

import DomainLiveInterface
import FeatureChatInterface
import DomainChatInterface

public final class LiveMainCoordinator: BaseCoordinator {
  public override var type: CoordinatorType {
    .live(.main)
  }
  
  private let featureLiveDependencyProvider: any FeatureLiveDependencyProvider

  public init(navigationController: CustomNavigationController, featureLiveDependencyProvider: any FeatureLiveDependencyProvider
  ) {
    self.featureLiveDependencyProvider = featureLiveDependencyProvider
    super.init(navigationController: navigationController)
  }
  
  deinit {
    self.deinitRootCoordinator()
  }
  
  public override func start() {
    let reactor = LiveMainReactor(
      matchConditionUseCase: featureLiveDependencyProvider.makeMatchConditionUseCase()
    )
    let liveController = LiveMainController(reactor: reactor)
    liveController.delegate = self
    navigationController.pushViewController(liveController, animated: false)

  }
}

extension LiveMainCoordinator: LiveMainControllerDelegate {
  func pushToMatchingView() {
    print("push - MatchingView")
  }
  
  func pushToCandyStore() {
    print("push - CandyStore")
  }
  
  func pushToMembershipView() {
    print("push - MembershipView")
  }
  
  func presentEditGenderConditionModal(_ matchState: MatchConditionState) {
    let liveMatchingReactor = LiveEditConditionModalReactor(
      matchState: matchState, 
      matchConditionUseCase: self.featureLiveDependencyProvider.makeMatchConditionUseCase(),
      connectMatchUserCase: self.featureLiveDependencyProvider.makeConnectMatchUseCase(), 
      getChatRoomUseCase: self.featureLiveDependencyProvider.makeGetChatRoomUseCase()
    )
    let editGenderConditionModal = LiveEditGenderConditionModal(reactor: liveMatchingReactor)
    editGenderConditionModal.modalPresentationStyle = .pageSheet
    editGenderConditionModal.delegate = self
    navigationController.present(editGenderConditionModal, animated: true)
  }
  
  func presentEditAgeConditionModal(_ matchState: MatchConditionState) {
    let liveMatchingReactor = LiveEditConditionModalReactor(
      matchState: matchState,
      matchConditionUseCase: self.featureLiveDependencyProvider.makeMatchConditionUseCase(),
      connectMatchUserCase: self.featureLiveDependencyProvider.makeConnectMatchUseCase(), 
      getChatRoomUseCase: self.featureLiveDependencyProvider.makeGetChatRoomUseCase()
    )
    let editAgeConditionModal = LiveEditAgeConditionModal(reactor: liveMatchingReactor)
    editAgeConditionModal.modalPresentationStyle = .pageSheet
    editAgeConditionModal.delegate = self
    navigationController.present(editAgeConditionModal, animated: true)
  }
  
  func presentMatchModeModal(_ matchState: MatchConditionState) {
    let liveMatchingReactor = LiveEditConditionModalReactor(
      matchState: matchState,
      matchConditionUseCase: self.featureLiveDependencyProvider.makeMatchConditionUseCase(),
      connectMatchUserCase: self.featureLiveDependencyProvider.makeConnectMatchUseCase(), 
      getChatRoomUseCase: self.featureLiveDependencyProvider.makeGetChatRoomUseCase()
    )
    let matchModeModal = LiveMatchModeModal(reactor: liveMatchingReactor)
    matchModeModal.modalPresentationStyle = .pageSheet
    matchModeModal.delegate = self
    navigationController.present(matchModeModal, animated: true)
  }
}

extension LiveMainCoordinator: LiveEditGenderConditionModalDelegate, LiveEditAgeConditionModalDelegate {
  public func dismiss() {
    DispatchQueue.main.async {
      self.navigationController.dismiss(animated: true)
    }
  }
  
  public func editFinished() {
    DispatchQueue.main.async {
      if let vc = self.navigationController.viewControllers.last as? LiveMainController {
        vc.reactor?.action.onNext(.viewWillAppear)
      }
      self.navigationController.dismiss(animated: true)
    }
  }
}

extension LiveMainCoordinator: LiveMatchModeModalDelegate {
  public func startMatching(_ matchState: MatchConditionState) {
    DispatchQueue.main.async {
      self.navigationController.dismiss(animated: true)
      
      let liveMatchingReactor = LiveEditConditionModalReactor(
        matchState: matchState,
        matchConditionUseCase: self.featureLiveDependencyProvider.makeMatchConditionUseCase(),
        connectMatchUserCase: self.featureLiveDependencyProvider.makeConnectMatchUseCase(),
        getChatRoomUseCase: self.featureLiveDependencyProvider.makeGetChatRoomUseCase()
      )
      let liveMatchingController = LiveMatchingController(reactor: liveMatchingReactor)
      liveMatchingController.modalPresentationStyle = .overFullScreen
      liveMatchingController.delegate = self
      self.navigationController.present(liveMatchingController, animated: true)
    }
  }
}

extension LiveMainCoordinator: LiveMatchingDelegate {
  func successMatching(room: ChatRoom) {
    print("successMatching - Matching")
    let chatCoordinatorDelegate = featureLiveDependencyProvider.getChatCoordinatorDelegate()
    if let chatCoordinator = chatCoordinatorDelegate as? Coordinator {
      addChildCoordinator(chatCoordinator)
    }
    DispatchQueue.main.async {
      self.navigationController.dismiss(animated: false)
      (chatCoordinatorDelegate as? ChatCoordinatorDelegate)?.pushToTemporaryChatRoom(roomData: room)
    }
  }
}
