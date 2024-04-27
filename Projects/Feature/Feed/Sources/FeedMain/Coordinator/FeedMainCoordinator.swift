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
    .feed(.main)
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
    let dataViewControllers: [UIViewController] = [
      FeedTypeTableView(reactor: FeedTypeTableReactor(getFeedsPageUseCase: featureProfileDependencyProvider.makeGetFeedsPageUseCase(), feedType: .lastest)),
      FeedTypeTableView(reactor: FeedTypeTableReactor(getFeedsPageUseCase: featureProfileDependencyProvider.makeGetFeedsPageUseCase(), feedType: .recommend)),
    ]
    let feedMainPageViewController = FeedMainPageViewController(dataViewControllers: dataViewControllers)
    
    let feedMainController = FeedMainController(reactor: reactor, FeedMainPageViewController: feedMainPageViewController)
    feedMainController.delegate = self
    navigationController.pushViewController(feedMainController, animated: true)
  }
}

extension FeedMainCoordinator: FeedMainControllerDelegate {
  func pushToNotificationView() {
    print("push - NotificationView")
  }
  
  func pushToFeedProfileView() {
    let feedProfileCoordinator = FeedProfileCoordinator(navigationController: navigationController, featureProfileDependencyProvider: featureProfileDependencyProvider)
    
    childCoordinators.append(feedProfileCoordinator)
    feedProfileCoordinator.finishDelegate = self
    feedProfileCoordinator.start()
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
  
  func successWrited(postId: Int) {
    navigationController.dismiss(animated: true)
  }
}

extension FeedMainCoordinator: PHPickerViewControllerDelegate {
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
