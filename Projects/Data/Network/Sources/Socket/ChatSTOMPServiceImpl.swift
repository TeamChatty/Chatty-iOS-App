//
//  STOMPProvider.swift
//  DataNetwork
//
//  Created by HUNHIE LEE on 2/14/24.
//

import Foundation
import RxSwift
import Starscream
import DataStorageInterface
import DataNetworkInterface
import DomainChatInterface
import DomainChat
import SharedUtil
import SwiftStomp

public class ChatSTOMPServiceImpl: ChatSTOMPService, SwiftStompDelegate {
  let url = URL(string: "wss://dev.api.chattylab.org/ws")!
  
  public static let shared = ChatSTOMPServiceImpl()
  private let socketStateSubject = PublishSubject<SocketState>()
  private let socketResultSubject = PublishSubject<ChatMessage>()
  
  private var swiftStomp: SwiftStomp?
  
  private init() {
    
  }
  
  public func connectSocket(token: String) -> PublishSubject<SocketState> {
    print("STOMP 스톰프 연결 시도")
    swiftStomp = SwiftStomp(host: url, headers: ["Authorization": "Bearer \(token)"])
    swiftStomp!.delegate = self
    swiftStomp!.connect(acceptVersion: "1.1, 1.2")
    return socketStateSubject
  }
  
  public func socketObserver() -> PublishSubject<ChatMessage> {
    return socketResultSubject
  }
  
  public func send(_ router: ChatSTOMPRouter) {
    guard let swiftStomp else { return }
    print("STOMP 메시지 전송 시도 \(router.command)")
    switch router {
    case .sendMessage(let chatMessageRequestDTO):
      swiftStomp.send(body: chatMessageRequestDTO, to: router.destination, receiptId: router.id, headers: router.headers, jsonDateEncodingStrategy: .iso8601)
    default:
      break
    }
  }
  
  public func subscribe(to: String) {
    guard let swiftStomp else { return }
    print("구독! \(to)")
    swiftStomp.subscribe(to:"/sub/chat/\(to)", mode: .auto)
  }
  
  public func unsubsribe(to: String) {
    guard let swiftStomp else { return }
    swiftStomp.unsubscribe(from: "/sub/chat/\(to)", mode: .auto)
  }
  
  public func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
    switch connectType {
    case .toSocketEndpoint:
      print("STOMP 소켓 연결됨")
      socketStateSubject.onNext(.socketConnected)
    case .toStomp:
      print("STOMP 스톰프 연결됨")
      socketStateSubject.onNext(.stompConnected)
    }
  }
  
  public func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
    socketStateSubject.onNext(.stompDisconnected)
  }
  
  public func onMessageReceived(swiftStomp: SwiftStomp, message: Any?, messageId: String, destination: String, headers: [String : String]) {
    guard let messageString = message as? String else { return }
    if let messageData = messageString.data(using: .utf8) {
      do {
        let decodeMessage = try JSONDecoder().decode(ChatMessageResponseDTO.self, from: messageData)
        let chatMessage = ChatMessage(content: .text(decodeMessage.data.content), senderId: decodeMessage.data.senderID, sendTime: Date(), roomId: decodeMessage.data.roomID)
        print("STOMP 메시지 받았다~")
        socketResultSubject.onNext(chatMessage)
      } catch {
        print("STOMP Error decoding message: \(error)")
      }
    }
  }
  
  public func onReceipt(swiftStomp: SwiftStomp, receiptId: String) {
    print("STOMP Receipt \(receiptId)")
  }
  
  public func onError(swiftStomp: SwiftStomp, briefDescription: String, fullDescription: String?, receiptId: String?, type: StompErrorType) {
    print("STOMP 에러 발생: \(fullDescription ?? "STOMP 에러 없음")")
  }
  
  public func onSocketEvent(eventName: String, description: String) {
    print("STOMP 소켓 이벤트 발생 \(eventName)")
  }
}
