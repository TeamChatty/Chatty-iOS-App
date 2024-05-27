//
//  DefaultChatAPIRepository.swift
//  DataRepository
//
//  Created by HUNHIE LEE on 2/13/24.
//

import Foundation
import DomainChatInterface
import DataNetworkInterface
import RxSwift

public struct DefaultChatAPIRepository: ChatAPIRepositoryProtocol {
  private let chatAPIService: any ChatAPIService
  
  public init(chatAPIService: any ChatAPIService) {
    self.chatAPIService = chatAPIService
  }
  
  public func fetchChatMessages(roomId: Int) -> Single<[ChatMessage]> {
    let request = ChatMessagesRequestDTO(roomId: roomId)
    return chatAPIService.request(endPoint: .messages(request), responseDTO: ChatMessagesResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  public func saveChatMessage(with message: ChatMessage) -> Single<Void> {
    return .just(())
  }
  
  public func fetchChatRooms() -> Single<[ChatRoom]> {
    return chatAPIService.request(endPoint: .getChatRooms, responseDTO: ChatRoomListResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  public func fetchChatRoom(roomId: Int) -> Single<ChatRoom> {
    return chatAPIService.request(endPoint: .getChatRoom(roomId: roomId), responseDTO: ChatRoomResponseDTO.self)
      .map { $0.toDomain() }
  }
  
  public func createChatRoom(receiverId: Int) -> Single<ChatRoom> {
    return chatAPIService.request(endPoint: .createChatRoom(senderId: 0, receiverId: receiverId), responseDTO: CreatChatRoomResponseDTO.self)
      .flatMap { response in
        return chatAPIService.request(endPoint: .getChatRoom(roomId: response.data.roomId), responseDTO: ChatRoomResponseDTO.self)
          .map { $0.toDomain() }
      }
  }
}
