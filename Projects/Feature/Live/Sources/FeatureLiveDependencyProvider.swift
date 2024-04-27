// This is for Tuist

import DomainLive
import DomainLiveInterface
import DomainChat
import SharedDesignSystem
import FeatureChatInterface

public protocol FeatureLiveDependencyProvider {
  associatedtype ChatCoordinatorDelegate
  var navigationController: CustomNavigationController { get }
  func makeConnectMatchUseCase() -> DefaultConnectMatchUseCase
  func makeMatchConditionUseCase() -> DefaultMatchConditionUseCase
  func makeGetChatRoomUseCase() -> DefaultGetChatRoomUseCase
  func getChatCoordinatorDelegate() -> ChatCoordinatorDelegate
}
