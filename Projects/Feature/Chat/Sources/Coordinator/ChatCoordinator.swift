//
//  ChatCoordinator.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 2/12/24.
//

import Foundation
import Shared
import SharedDesignSystem
import FeatureChatInterface
import DomainLiveInterface
import DomainChatInterface


public final class ChatCoordinator: BaseCoordinator, ChatCoordinatorDelegate {
  public override var type: CoordinatorType {
    return .chat
  }
  
  private let dependencyProvider: FeatureChatDependecyProvider
  
  public init(navigationController: CustomNavigationController, dependencyProvider: FeatureChatDependecyProvider) {
    self.dependencyProvider = dependencyProvider
    super.init(navigationController: navigationController)
  }
  
  public override func start() {
    let chatListController = ChatListController(reactor: ChatListReactor(
      chatServerConnectUseCase:dependencyProvider.makeChatServerConnectUseCase(),
      getChatRoomListUseCase: dependencyProvider.makeGetChatRoomListUseCase(), 
      chatRoomSubscribeUseCase: dependencyProvider.makeChatRoomSubscribeUseCase(), getChatMessageStreamUseCase: dependencyProvider.makeGetChatMessageStreamUseCase())
    )
    chatListController.delegate = self
    navigationController.pushViewController(chatListController, animated: true)
  }
  
  public func pushToChatRoom(roomViewData: ChatRoomViewData) {
    let chatRoomController = ChatRoomController(reactor: ChatReactor(chatServerConnectUseCase: dependencyProvider.makeChatServerConnectUseCase(), chatSendMessageUseCase: dependencyProvider.makeChatSendMessageUseCase(), chatRoomSubscribeUseCase: dependencyProvider.makeChatRoomSubscribeUseCase(), getChatMessageStreamUseCase: dependencyProvider.makeGetChatMessageStreamUseCase(), getChatMessagesUseCase: dependencyProvider.makeGetChatMessagesUseCase(), roomViewData: roomViewData))
    chatRoomController.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(chatRoomController, animated: true)
  }
  
  public func pushToTemporaryChatRoom(roomData: ChatRoom) {
    let roomViewData = ChatRoomViewData(roomId: roomData.roomId, recieverProfile: .init(userId: roomData.partnerId, name: roomData.partnerNickname, profileImageURL: roomData.partnerImageURL), chatRoomActiveStatus: .temporary(creationTime: roomData.chatRoomCreatedTime), createdTime: roomData.chatRoomCreatedTime)
    let temporaryChatRoomController = TemporaryChatRoomController(reactor: ChatReactor(chatServerConnectUseCase: dependencyProvider.makeChatServerConnectUseCase(), chatSendMessageUseCase: dependencyProvider.makeChatSendMessageUseCase(), chatRoomSubscribeUseCase: dependencyProvider.makeChatRoomSubscribeUseCase(), getChatMessageStreamUseCase: dependencyProvider.makeGetChatMessageStreamUseCase(), getChatMessagesUseCase: dependencyProvider.makeGetChatMessagesUseCase(), roomViewData: roomViewData), temporaryChatReactor: TemporaryChatReactor())
    temporaryChatRoomController.hidesBottomBarWhenPushed = true
    navigationController.pushViewController(temporaryChatRoomController, animated: true)
  }
}
