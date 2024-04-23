//
//  FeedMainCoordinator.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/15/24.
//

import UIKit
import PhotosUI
import Shared
import SharedDesignSystem
import SharedUtil
import FeatureFeedInterface

import RxSwift
public final class FeedMainCoordinator: BaseCoordinator, FeedMainCoordinatorProtocol {
  public override var type: CoordinatorType {
    .feed
  }
  
  private var madalNavigationController: UINavigationController?
  
  private let featureProfileDependencyProvider: FeatureFeedDependencyProvider

  public init(navigationController: CustomNavigationController, featureProfileDependencyProvider: FeatureFeedDependencyProvider) {
    self.featureProfileDependencyProvider = featureProfileDependencyProvider
    super.init(navigationController: navigationController)
  }
  
  deinit {
    print("해제됨: FeedMainCoordinator")
  }
  
  let disposeBag = DisposeBag()
  public override func start() {
    let reactor = FeedMainReactor()
    let feedMainController = FeedMainController(reactor: reactor)
    feedMainController.delegate = self
    navigationController.pushViewController(feedMainController, animated: true)
    
    let useCase = featureProfileDependencyProvider.makeWriteFeedUseCase()
    
    let images: [Data] = [
      Images.bell.image,
      Images.bell.image,
      Images.bell.image,
      Images.bell.image,
    ].map { $0.toProfileRequestData() }
    
    let a = useCase.execute(title: "1", content: "dawd", images: images)
    a.subscribe(onNext: { feed in
        print(feed)
      })
      .disposed(by: disposeBag)
  }
}

extension FeedMainCoordinator: FeedMainControllerDelegate {
  func pushToNotificationView() {
    print("push - NotificationView")
  }
  
  func pushToFeedProfileView() {
    print("push - FeedProfileView")
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

extension FeedMainCoordinator: FeedWriteModalDelegate {
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
  
  func successWrited() {
    navigationController.dismiss(animated: true)
  }
}

extension FeedMainCoordinator: PHPickerViewControllerDelegate {
  public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    var images: [UIImage] = []
    
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
