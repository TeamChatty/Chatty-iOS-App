//
//  FeatureLiveDIcontainer.swift
//  Chatty
//
//  Created by 윤지호 on 3/4/24.
//

import Foundation
import FeatureLive
import FeatureChatInterface
import DomainLive
import DomainChat
import FeatureChat
import SharedDesignSystem

final class FeatureLiveDIcontainer: RepositoryDIcontainer, FeatureLiveDependencyProvider {
  var navigationController: CustomNavigationController = CustomNavigationController()
  
  func getChatCoordinatorDelegate() -> ChatCoordinatorDelegate {
    return ChatCoordinator(
      navigationController: navigationController,
      dependencyProvider: AppDIContainer.shared.makeFeatureChatDependencyProvider()
    )
  }
  
  func makeConnectMatchUseCase() -> DefaultConnectMatchUseCase {
    return DefaultConnectMatchUseCase(
      liveAPIRepository: makeLiveAPIRepository(),
      liveSocketRepository: makeLiveSocketRepository()
    )
  }
  
  func makeMatchConditionUseCase() -> DefaultMatchConditionUseCase {
    return DefaultMatchConditionUseCase(
      userDefaultsRepository: makeUserDefaultsRepository()
    )
  }
  
  func makeGetChatRoomUseCase() -> DefaultGetChatRoomUseCase {
    return DefaultGetChatRoomUseCase(
      chatAPIRepository: makeChatAPIRepository()
    )
  }
}
