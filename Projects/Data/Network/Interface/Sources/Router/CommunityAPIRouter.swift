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
  case getMyComments(GetMyCommnetsRequestDTO)
  
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
  case reportUser(userId: Int, content: ReportUserRequestDTO)
}

public extension CommunityAPIRouter {
  var baseURL: URL {
    let url = URL(string: Environment.baseURL + basePath)!
    return url
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
      
    case .getMyComments(let requestDTO):
      return "/v1/my-comments?lastCommentId=\(requestDTO.lastCommentId)&size=\(requestDTO.size)"
      
    /// Report
    case .reportBlock(userId: let userId):
      return "/v1/block/\(userId)"
    case .reportUser(let userId, _):
      return "/v1/report/\(userId)"
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
    case .getComments, .getCommentReplies, .getMyComments:
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
    case .reportBlock, .reportUser:
      return ""
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getPost, .getPosts, .getTopLikedPosts, .getMyBookmarkPosts, .getMyPosts, .getComments, .getCommentReplies, .getMyComments:
      return .get
    case .writePost, .writeComment, .writeCommentReply , .postLike, .postBookmark, .reportBlock, .reportUser, .commentLike:
      return .post
    case .postLikeDelete, .postBookmarkDelete, .commentLikeDelete:
      return .delete
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .getPost, .getComments, .getCommentReplies, .getMyComments:
      return .requestPlain

    case .getPosts, .getTopLikedPosts, .getMyBookmarkPosts, .getMyPosts:
      return .requestPlain
      
    case .postLike, .postBookmark, .postLikeDelete, .postBookmarkDelete:
      return .requestPlain
      
    case .reportBlock:
      return .requestPlain

    case .reportUser( _, let content):
      return .requestJSONEncodable(content)
      
      
    case .writePost(let requestDTO):
      var multipartFormDatas: [MultipartFormData] = []
      let contentData = MultipartFormData(provider: .data(requestDTO.content.data(using: .utf8)!), name: "content")
      
      multipartFormDatas.append(contentData)
      
      if requestDTO.images.isEmpty == false {
        for (index, image) in requestDTO.images.enumerated() {
          let imageData = MultipartFormData(provider: .data(image), name: "images", fileName: "image_\(index)", mimeType: "image/jpeg")

          multipartFormDatas.append(imageData)
        }
        
      }
      return .uploadMultipart(multipartFormDatas)

      
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
