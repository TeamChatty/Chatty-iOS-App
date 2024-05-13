//
//  CommunityAPIRouter.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation
import Moya

public enum CommunityAPIRouter: RouterProtocol, AccessTokenAuthorizable {
  /// Write Post
  case writePost(WriteFeedRequestDTO)
  
  /// Posts Page
  case getPosts(GetFeedPageRequestDTO)
  case getTopLikedPosts(GetFeedPageRequestDTO)
  case getMyBookmarkPosts(GetFeedPageRequestDTO)
  case getMyPosts(GetFeedPageRequestDTO)
  
  /// Post
  case getPost(PostRequestId)
  
  /// Comment
  case writeComment(requestIds: PostRequestId, requestDTO: WriteCommonCommentReqeustDTO)
  case writeCommentReply(requestIds: CommentRequestIds, requestDTO: WriteCommonCommentReqeustDTO)
  case getComments(GetCommnetsRequestDTO)
  case getCommentReplies(GetRepliesRequestDTO)
  
  /// Like
  case postLike(PostRequestId)
  case postLikeDelete(PostRequestId)
  
  case commentLike(commentId: Int)
  case commentLikeDelete(commentId: Int)
  
  /// Bookmark
  case postBookmark(PostRequestId)
  case postBookmarkDelete(PostRequestId)
  
  /// Report
  case reportBlock(userId: Int)
  case reportPost
}

public extension CommunityAPIRouter {
  var baseURL: URL {
    return URL(string: Environment.baseURL + basePath)!
  }
  
  var basePath: String {
    switch self {
    /// Posts Page
    case .getPosts(let requestDTO):
      return "/v2/posts?lastPostId=\(requestDTO.lastPostId)&size=\(requestDTO.size)"
    case .getTopLikedPosts(let requestDTO):
      return "/v1/posts/top-liked?lastLikeCount=\(requestDTO.lastPostId)&size=\(requestDTO.size)"
    case .getMyBookmarkPosts(let requestDTO):
      return "/v1/my-bookmarks?lastBookmarkId=\(requestDTO.lastPostId)&size=\(requestDTO.size)"
    case .getMyPosts(let requestDTO):
      return "/v1/my-posts?lastPostId=\(requestDTO.lastPostId)&size=\(requestDTO.size)"

    case .postLike, .postLikeDelete, .postBookmark, .postBookmarkDelete, .commentLike, .commentLikeDelete:
      return "/v1"
      
    /// Comment / Reply
    case .getComments(let requestDTO):
      return "/v2/post/\(requestDTO.postId)/comments?lastCommentId=\(requestDTO.lastCommentId)&size=\(requestDTO.size)"
    case .getCommentReplies(let requestDTO):
      return "/v2/comment-replies/\(requestDTO.commentId)?lastCommentId=\(requestDTO.lastCommentId)&size=\(requestDTO.size)"
      
    /// Report
    case .reportBlock(userId: let userId):
      return "/v1/block/\(userId)"
    case .reportPost:
      return "/v1/block"
    default:
      return "/v1/post"
    }
  }
  
  var path: String {
    switch self {
    /// Write Post
    case .writePost:
      return ""
     
    /// Posts Page
    case .getPosts, .getTopLikedPosts, .getMyBookmarkPosts, .getMyPosts:
      return ""
      
      /// Post
    case .getPost(let requestId):
      return "/\(requestId.postId)"
      
    /// Comment
    case .writeComment(let requestId, _):
      return "/\(requestId.postId)/comment"
    case .writeCommentReply(let requestIds, _):
      return "/\(requestIds.postId)/comment/\(requestIds.commentId)/comment-reply"
    case .getComments, .getCommentReplies:
      return ""
    
    /// Like
    case .postLike(postId: let requestId):
      return "/\(requestId.postId)/like"
    case .postLikeDelete(postId: let requestId):
      return "/\(requestId.postId)/like"

    case .commentLike(commentId: let commentId):
      return "/comment-like/\(commentId)"
    case .commentLikeDelete(commentId: let commentId):
      return "/comment-like/\(commentId)"

    /// Bookmark
    case .postBookmark(let requestId):
      return "/\(requestId.postId)/bookmark"
    case .postBookmarkDelete(let requestId):
      return "/\(requestId.postId)/bookmark"
      
    /// Report
    case .reportBlock, .reportPost:
      return ""
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getPost, .getPosts, .getTopLikedPosts, .getMyBookmarkPosts, .getMyPosts, .getComments, .getCommentReplies:
      return .get
    case .writePost, .writeComment, .writeCommentReply , .postLike, .postBookmark, .reportBlock, .reportPost, .commentLike:
      return .post
    case .postLikeDelete, .postBookmarkDelete, .commentLikeDelete:
      return .delete
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .getPost, .getComments, .getCommentReplies:
      return .requestPlain

    case .getPosts, .getTopLikedPosts, .getMyBookmarkPosts, .getMyPosts:
      return .requestPlain
      
    case .postLike, .postBookmark, .postLikeDelete, .postBookmarkDelete:
      return .requestPlain
      
    case .reportBlock, .reportPost:
      return .requestPlain

    case .writePost(let requestDTO):
      if requestDTO.images.isEmpty {
        let titleData = MultipartFormData(provider: .data(requestDTO.title.data(using: .utf8)!), name: "title")
        let dataData = MultipartFormData(provider: .data(requestDTO.content.data(using: .utf8)!), name: "content")
        return .uploadMultipart([titleData, dataData])
      } else {
        
        let titleData = MultipartFormData(provider: .data(requestDTO.title.data(using: .utf8)!), name: "title")
        let dataData = MultipartFormData(provider: .data(requestDTO.content.data(using: .utf8)!), name: "content")
        return .uploadMultipart([titleData, dataData])
      }
      
    case .commentLike, .commentLikeDelete:
      return .requestPlain
     
    case .writeComment(_ , let requestDTO):
      return .requestJSONEncodable(requestDTO)
    case .writeCommentReply(_ , let requestDTO):
      return .requestJSONEncodable(requestDTO)
    }
  }
  
  
  
  var headers: [String : String]? {
    switch self {
    case .writePost:
      return RequestHeader.getHeader([.binary])
    default:
      return RequestHeader.getHeader([.json])
    }
  }
  
  var authorizationType: Moya.AuthorizationType? {
    switch self {
    default:
      return .bearer
    }
  }
}
