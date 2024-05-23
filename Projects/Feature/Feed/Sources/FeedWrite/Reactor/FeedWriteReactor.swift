//
//  FeedWriteReactor.swift
//  FeatureFeedInterface
//
//  Created by 윤지호 on 4/19/24.
//

import UIKit
import ReactorKit
import DomainCommunityInterface
import DomainCommon

final class FeedWriteReactor: Reactor {
  private let writefeedUseCase: WriteFeedUseCase
  
  enum Action {
    case inputImage([UIImage])
    case inputText(String)
    case removeImage(imageId: String)
    case tabChangeButton
  }
  
  enum Mutation {
    case setInputText(String)
    case setImages([AddedImage])
    case setLastSelectedImages([AddedImage])
    case setLastRemovedImageId(String)
    
    case isLoading(Bool)
    case setIsChangeButtonEnabled(Bool)
    case setIsSaveSuccess(postId: Int)
    case setError(ErrorType?)
  }
  
  struct State {
    var inputedNicknameText: String = ""
    var inputtedImages: [AddedImage] = []
    var lastInputedImage: [AddedImage]? = nil
    var lastRemovedImageId: String? = nil
    
    var isLoading: Bool = false
    var isChangeButtonEnabled = false
    var isSaveSuccessPostId: Int? = nil
    var errorState: ErrorType? = nil
  }
  
  var initialState: State
  
  public init(writefeedUseCase: WriteFeedUseCase) {
    self.writefeedUseCase = writefeedUseCase
    self.initialState = State()
  }
  
  public enum ErrorType: Error {
    case unknownError
    
    var description: String {
      switch self {
      case .unknownError:
        return "문제가 생겼어요. 다시 시도해주세요."
      }
    }
  }
}

extension FeedWriteReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .inputImage(let selectedImages):
      let selectedImages = selectedImages.map { AddedImage(image: $0) }
      var images = currentState.inputtedImages
      images += selectedImages
      return . concat([
        .just(.setImages(images)),
        .just(.setLastSelectedImages(selectedImages))
      ])
    case .removeImage(imageId: let imageId):
      var images = currentState.inputtedImages
      if let index = images.firstIndex(where: { $0.id == imageId}) {
        images.remove(at: index)
        return .concat([
            .just(.setImages(images)),
            .just(.setLastRemovedImageId(imageId))
          ])
      } else {
        return .just(.setImages(images))
      }
      
    case .inputText(let text):
      var isChangeButtonEnabled: Bool = text.isEmpty ? false : true
      return .concat([
        .just(.setInputText(text)),
        .just(.setIsChangeButtonEnabled(isChangeButtonEnabled))
      ])
      
      
    case .tabChangeButton:
      let images = currentState.inputtedImages.map { $0.image.toProfileRequestData() }
      let content = currentState.inputedNicknameText
      return .concat([
        .just(.isLoading(true)),
        writefeedUseCase.execute(content: content, images: images)
          .map { post in
            return .setIsSaveSuccess(postId: post.postId)
          }
          .catch { error -> Observable<Mutation> in
            return error.toMutation()
          },
        .just(.isLoading(false))
      ])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .isLoading(let bool):
      newState.isLoading = bool
    case .setIsSaveSuccess(postId: let postId):
      newState.isSaveSuccessPostId = postId
      
    case .setInputText(let text):
      newState.inputedNicknameText = text
      if newState.errorState != nil {
        newState.errorState = nil
      }
      
    case .setIsChangeButtonEnabled(let bool):
      newState.isChangeButtonEnabled = bool
    case .setError(let error):
      newState.errorState = error
    case .setImages(let images):
      newState.inputtedImages = images
    case .setLastSelectedImages(let image):
      newState.lastInputedImage = image
    case .setLastRemovedImageId(let imageId):
      newState.lastRemovedImageId = imageId
    }
    return newState
  }
}

extension Error {
  func toMutation() -> Observable<FeedWriteReactor.Mutation> {
    let errorMutation: Observable<FeedWriteReactor.Mutation> = {
      guard let error = self as? NetworkError else {
        return .just(.setError(.unknownError))
      }
      switch error.errorCase {
      default:
        return .just(.setError(.unknownError))
      }
    }()
    
    return Observable.concat([
      errorMutation
    ])
  }
}


