//
//  ChatAPIRouter.swift
//  DataNetworkInterface
//
//  Created by HUNHIE LEE on 2/13/24.
//

import Foundation
import Moya

public enum ChatAPIRouter: RouterProtocol, AccessTokenAuthorizable {
  case messages(ChatMessagesRequestDTO)
  case createChatRoom(senderId: Int, receiverId: Int)
  case deleteChatRoom(roomId: Int, userId: Int)
  case getChatRoomInfo(roomId: Int)
  case getChatRooms
  case getChatRoom(roomId: Int)
}

public extension ChatAPIRouter {
  var baseURL: URL {
    return URL(string: Environment.baseURL + basePath)!
  }
  
  var basePath: String {
    return "/chat"
  }
  
  var path: String {
    switch self {
    case .messages(let request):
      return "/messages/\(request.roomId)"
    case .createChatRoom, .deleteChatRoom:
      return "/room"
    case .getChatRoomInfo(let roomId):
      return "/room/\(roomId)"
    case .getChatRooms:
      return "/rooms"
    case .getChatRoom(roomId: let roomId):
      return "/room/\(roomId)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .createChatRoom:
      return .post
    case .deleteChatRoom:
      return .delete
    case .getChatRoomInfo:
      return .get
    case .getChatRooms:
      return .get
    case .messages:
      return .get
    case .getChatRoom(roomId: let roomId):
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .messages:
      return .requestPlain
    case .createChatRoom(let senderId, let receiverId):
      let param = ["senderId": senderId, "receiverId": receiverId]
      return .requestParameters(parameters: param, encoding: JSONEncoding.default)
    case .deleteChatRoom(let roomId, let userId):
      let param = ["roomId": roomId, "userId": userId]
      return .requestParameters(parameters: param, encoding: JSONEncoding.default)
    case .getChatRoomInfo:
      return .requestPlain
    case .getChatRooms:
      return .requestPlain
    case .getChatRoom(roomId: let roomId):
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .messages, .createChatRoom, .deleteChatRoom, .getChatRoomInfo, .getChatRooms, .getChatRoom:
      return RequestHeader.getHeader([.json])
    }
  }
  
  var authorizationType: Moya.AuthorizationType? {
    switch self {
    case .messages, .createChatRoom, .deleteChatRoom, .getChatRoomInfo, .getChatRooms, .getChatRoom:
      return .bearer
    }
  }
}

