//
//  FeedProfileCoordinator.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/26/24.
//


import UIKit
import PhotosUI
import Shared
import SharedDesignSystem
import SharedUtil
import FeatureFeedInterface

import RxSwift
public final class FeedProfileCoordinator: BaseCoordinator, FeedMainCoordinatorProtocol {
  public override var type: CoordinatorType {
    .feed(.profile)
  }
  
  private var madalNavigationController: UINavigationController?
  
  private let featureProfileDependencyProvider: FeatureFeedDependencyProvider

  public init(navigationController: CustomNavigationController, featureProfileDependencyProvider: FeatureFeedDependencyProvider) {
    self.featureProfileDependencyProvider = featureProfileDependencyProvider
    super.init(navigationController: navigationController)
  }
  
  deinit {
    print("해제됨: FeedProfileCoordinator")
  }
  
  let disposeBag = DisposeBag()
  
  public override func start() {
    let reactor = FeedProfileReactor()
    let feedProfileController = FeedProfileController(reactor: reactor)
    feedProfileController.delegate = self
    navigationController.pushViewController(feedProfileController, animated: true)
  }
}

extension FeedProfileCoordinator: FeedProfileControllerDelegate {
  func popToFeedMain() {
    _ = navigationController.popViewController(animated: true)
  }
  
  func presentFeedWriteModal() {
   
    let reactor = FeedWriteReactor(writefeedUseCase: featureProfileDependencyProvider.makeWriteFeedUseCase())
    let modal = FeedWriteModal(reactor: reactor)
    modal.delegate = self
    
    madalNavigationController = UINavigationController(rootViewController: modal)
    if let madalNavigationController {
      madalNavigationController.modalPresentationStyle = .fullScreen
      navigationController.present(madalNavigationController, animated: true)
    }
  }
}

extension FeedProfileCoordinator: FeedWriteModalDelegate {
  func dismiss() {
    navigationController.dismiss(animated: true)
  }
  
  func presentSelectImage(nowAddedCount: Int) {
    var configuration = PHPickerConfiguration()
    configuration.selectionLimit = 5 - nowAddedCount
    configuration.filter = .any(of: [.images])
    
    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = self
    
    if let madalNavigationController {
      madalNavigationController.present(picker, animated: true)
    }
  }
  
  func successWrited(postId: Int) {
    if let feedProfileController = navigationController.viewControllers.last as? FeedProfileController {
      feedProfileController.reactor?.action.onNext(.feedWrited)
    }
    navigationController.dismiss(animated: true)
  }
}

extension FeedProfileCoordinator: PHPickerViewControllerDelegate {
  public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    var images: [UIImage] = []
    
    if results.isEmpty {
      picker.dismiss(animated: true)
    } else {
      for result in results {
        let itemProvider = result.itemProvider
        
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
          itemProvider.loadObject(ofClass: UIImage.self) { image, error in
            guard let image = image as? UIImage else { return }
            images.append(image)
            if images.count == results.count {
              DispatchQueue.main.async {
                if let madalNavigationController = self.madalNavigationController,
                   let vc = madalNavigationController.viewControllers[0] as? FeedWriteModal {
                  vc.reactor?.action.onNext(.inputImage(images))
                }
                picker.dismiss(animated: true)
              }
            }
          }
        }
      }
    }
  }
}
