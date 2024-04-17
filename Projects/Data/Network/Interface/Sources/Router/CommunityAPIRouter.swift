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
      
      if let images = requestDTO.images {
        let data = createMultiImageMultiPartBody(boundary: "", imageDataArray: images)
        let imagesMultipartFormData = MultipartFormData(provider: .data(data), name: "images", fileName: "feed_image", mimeType: "image/jpeg")
        
        
        let titleData = MultipartFormData(provider: .data(requestDTO.title.data(using: .utf8)!), name: "title")
        let dataData = MultipartFormData(provider: .data(requestDTO.content.data(using: .utf8)!), name: "content")
        return .uploadMultipart([titleData, dataData, imagesMultipartFormData])
      } else {
        let titleData = MultipartFormData(provider: .data(requestDTO.title.data(using: .utf8)!), name: "title")
        let dataData = MultipartFormData(provider: .data(requestDTO.content.data(using: .utf8)!), name: "content")
        return .uploadMultipart([titleData, dataData])
      }
     
    case .writeComment(_ , let requestDTO):
      return .requestJSONEncodable(requestDTO)
    case .writeCommentReply(_ , let requestDTO):
      return .requestJSONEncodable(requestDTO)
    }
  }
  
  func createMultiImageMultiPartBody(boundary : String,imageDataArray : [Data]) -> Data {
    var body = Data()
    
    let mimetype = "image/jpg"
    
    for imageData in imageDataArray {
      body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
      body.append("Content-Disposition: form-data; name=\"externalImages\"; filename=\"\(Date().timeIntervalSince1970).jpg\"\r\n".data(using: String.Encoding.utf8)!)
      
      body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
      body.append(imageData)
      body.append("\r\n".data(using: String.Encoding.utf8)!)
      
    }
    // Just take this line out of the images loop
    body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
    return body
  }
  
  var headers: [String : String]? {
    switch self {
    case .writePost:
      return RequestHeader.getHeader([.binary])
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

extension MultipartFormData {
  
}
