//
//  CommunityAPIRouter.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation
import Moya

public enum CommunityAPIRouter: RouterProtocol, AccessTokenAuthorizable {
  case writePost(WriteFeedRequestDTO)
  case getPosts
  case getPost(PostRequestId)
  
  case writeComment(requestIds: PostRequestId, requestDTO: WriteCommonCommentReqeustDTO)
  case writeCommentReply(requestIds: CommentRequestIds, requestDTO: WriteCommonCommentReqeustDTO)
  case getComment(PostRequestId)
  case getCommentReplies(CommentRequestIds)
}

public extension CommunityAPIRouter {
  var baseURL: URL {
    return URL(string: Environment.baseURL + basePath)!
  }
  
  var basePath: String {
    return "/v1/post"
  }
  
  var path: String {
    switch self {
    case .writePost:
      return ""
    case .getPosts:
      return "s"
    case .getPost(let requestId):
      return "/\(requestId.postId)"
      
    case .writeComment(let requestId, let requestDTO):
      return "/\(requestId.postId)/comment"
    case .writeCommentReply(let requestIds, let requestDTO):
      return "/\(requestIds.postId)/comment/\(requestIds.commentId)/comment-reply"
    case .getComment(let requestId):
      return "/\(requestId.postId)/comments"
    case .getCommentReplies(let requestIds):
      return "/\(requestIds.postId)/comment/\(requestIds.commentId)/comment-replies"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getPost, .getPosts, .getComment, .getCommentReplies:
      return .get
    case .writePost, .writeComment, .writeCommentReply:
      return .post
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .getPost, .getPosts, .getComment, .getCommentReplies:
      return .requestPlain
    case .writePost(let requestDTO):
      return .requestJSONEncodable(requestDTO)
    case .writeComment(let requestId, let requestDTO):
      return .requestJSONEncodable(requestDTO)
    case .writeCommentReply(let requestId, let requestDTO):
      return .requestJSONEncodable(requestDTO)
//    case .profileUnlock(_, let method):
//      let param = ["unlockMethod": "\(method.rawValue)"]
//      return .requestParameters(parameters: param, encoding: JSONEncoding.default)
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .writePost:
      return RequestHeader.getHeader([.json, .binary])
    case .writeComment, .writeCommentReply:
      return RequestHeader.getHeader([.json])
    default:
      return nil
    }
  }
  
  var authorizationType: Moya.AuthorizationType? {
    switch self {
    case .writePost, .writeComment, .writeCommentReply,.getPost, .getPosts, .getComment, .getCommentReplies:
      return .bearer
    }
  }
}

