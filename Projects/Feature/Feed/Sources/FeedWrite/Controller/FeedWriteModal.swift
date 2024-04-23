//
//  FeedWrite.swift
//  FeatureFeedInterface
//
//  Created by 윤지호 on 4/19/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ReactorKit
import SharedDesignSystem

protocol FeedWriteModalDelegate: AnyObject {
  func dismiss()
  func presentSelectImage(nowAddedCount: Int)
  func successWrited()
}

final class FeedWriteModal: BaseController {
  // MARK: - View Property
  private let mainView = FeedWriteModalView()
  
  // MARK: - Reactor Property
  typealias Reactor = FeedWriteReactor
  
  // MARK: - Delegate
  weak var delegate: FeedWriteModalDelegate?
  
  // MARK: - Initialize Method
  required init(reactor: Reactor) {
    defer {
      self.reactor = reactor
    }
    super.init()
  }
  
  // MARK: - UIConfigurable
  override func configureUI() {
    navigationController?.isNavigationBarHidden = true
    self.view = mainView
  }
  
  deinit {
    print("해제됨: FeedWriteModal")
  }
}

extension FeedWriteModal: ReactorKit.View {
  func bind(reactor: FeedWriteReactor) {
    mainView.touchEventRelay
      .bind(with: self) { owner, event in
        switch event {
        case .cancel:
          owner.mainView.removeButton()
          owner.delegate?.dismiss()
        case .inputText(let string):
          owner.reactor?.action.onNext(.inputText(string))
        case .addImage:
          let nowAddedCount: Int = owner.reactor?.currentState.inputtedImages.count ?? 0
          owner.delegate?.presentSelectImage(nowAddedCount: nowAddedCount)
        case .removeImage(identifier: let identifier):
          owner.reactor?.action.onNext(.removeImage(imageId: identifier))
        case .save:
          owner.mainView.removeButton()
          owner.delegate?.successWrited()
        
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.lastInputedImage)
      .distinctUntilChanged()
      .bind(with: self) { owner, images in
        guard let images else { return }
        print("1. lastInputedImage ==> \(images)")
        owner.mainView.updateAddedImages(images: images)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.inputtedImages)
      .distinctUntilChanged()
      .bind(with: self) { owner, images in
        print("2. inputtedImages ==> \(images)")
        owner.mainView.updateAddedImagesCount(count: images.count)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.lastRemovedImageId)
      .distinctUntilChanged()
      .bind(with: self) { owner, imageId in
        guard let imageId else { return }
        owner.mainView.updateRemovedImage(imageId: imageId)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.isSaveSuccessPostId)
      .distinctUntilChanged()
      .bind(with: self) { owner, postId in
        guard let postId else { return }
        owner.delegate?.successWrited()
      }
      .disposed(by: disposeBag)
  }
}

