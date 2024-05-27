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

import FeatureChatInterface
import FeatureFeedInterface
import DomainCommunityInterface
import DomainChatInterface

import RxSwift
public final class FeedMainCoordinator: BaseCoordinator, FeedMainCoordinatorProtocol {
  public override var type: CoordinatorType {
    .feed(.main)
  }
  
  private var madalNavigationController: UINavigationController?
  
  private let featureFeedDependencyProvider: any FeatureFeedDependencyProvider

  public init(navigationController: CustomNavigationController, featureProfileDependencyProvider: any FeatureFeedDependencyProvider) {
    self.featureFeedDependencyProvider = featureProfileDependencyProvider
    super.init(navigationController: navigationController)
  }
  
  deinit {
    self.deinitRootCoordinator()
  }
  
  let disposeBag = DisposeBag()
  
  public override func start() {
    let reactor = FeedMainReactor()
    let dataViewControllers: [UIViewController] = [
      FeedTypeTableView(reactor: FeedTypeTableReactor(
        getFeedsPageUseCase: featureFeedDependencyProvider.makeGetFeedsPageUseCase(),
        setBookmarkAndLikeUseCase: featureFeedDependencyProvider.makeSetBookmarkAndLikeUseCase(),
        reportUseCase: featureFeedDependencyProvider.makeReportUseCase(),
        feedType: .recent)),
      FeedTypeTableView(reactor: FeedTypeTableReactor(
        getFeedsPageUseCase: featureFeedDependencyProvider.makeGetFeedsPageUseCase(),
        setBookmarkAndLikeUseCase: featureFeedDependencyProvider.makeSetBookmarkAndLikeUseCase(),
        reportUseCase: featureFeedDependencyProvider.makeReportUseCase(),
        feedType: .topLiked)),
    ]
    let feedMainPageViewController = FeedMainPageViewController(dataViewControllers: dataViewControllers)
    
    let feedMainController = FeedMainController(reactor: reactor, FeedMainPageViewController: feedMainPageViewController)
    feedMainController.delegate = self
    navigationController.pushViewController(feedMainController, animated: true)
  }
}

extension FeedMainCoordinator: FeedChatModalControllerDelegate {
  func successMatching(room: ChatRoom) {
    print("successMatching - Matching")
   
    DispatchQueue.main.async {
      let chatCoordinatorDelegate = self.featureFeedDependencyProvider.getChatCoordinatorDelegate2(navigationController: self.navigationController)
      if let chatCoordinator = chatCoordinatorDelegate as? Coordinator,
         let chatCoordinatorDelegate = chatCoordinator as? ChatCoordinatorDelegate {
        
        self.addChildCoordinator(chatCoordinator)
        self.navigationController.dismiss(animated: false)
        chatCoordinatorDelegate.pushToChatRoomFromFeed(roomData: room)
      }
    }
  }
}

extension FeedMainCoordinator: FeedMainControllerDelegate {
  func presentStartChatModal(receiverId: Int) {
    let reactor = FeedChatModalReactor(getSomeoneProfileUseCase: featureFeedDependencyProvider.makeGetSomeoneProfileUseCaseTemp(), creatChatRoomUseCase: featureFeedDependencyProvider.makeCreatChatRoomUseCase(), someoneId: receiverId)
    let modal = FeedChatModalController(reactor: reactor)
    modal.delegate = self
    
    navigationController.present(modal, animated: true)
  }
    
  
  func pushToDetailView(postId: Int) {
    let feedDetailCoordinator = FeedDetailCoordinator(navigationController: navigationController, featureFeedDependencyProvider: featureFeedDependencyProvider)
    
    feedDetailCoordinator.finishDelegate = self
    childCoordinators.append(feedDetailCoordinator)
    
    feedDetailCoordinator.start(postId: postId)
  }
  
  
  func pushToNotificationView() {
    print("push - NotificationView")
  }
  
  func pushToFeedProfileView() {
    let feedProfileCoordinator = FeedProfileCoordinator(navigationController: navigationController, featureFeedDependencyProvider: featureFeedDependencyProvider)
    
    childCoordinators.append(feedProfileCoordinator)
    feedProfileCoordinator.finishDelegate = self
    feedProfileCoordinator.start()
  }
  
  func presentFeedWriteModal() {
   
    let reactor = FeedWriteReactor(writefeedUseCase: featureFeedDependencyProvider.makeWriteFeedUseCase())
    let modal = FeedWriteModal(reactor: reactor)
    modal.delegate = self
    
    madalNavigationController = UINavigationController(rootViewController: modal)
    if let madalNavigationController {
      madalNavigationController.modalPresentationStyle = .fullScreen
      navigationController.present(madalNavigationController, animated: true)
    }
  }
  
  func presentReportModal(userId: Int) {
    let reactor = FeedReportReactor(reportUseCase: featureFeedDependencyProvider.makeReportUseCase(), userId: userId)
    let modal = FeedReportModalController(reactor: reactor)
    modal.delegate = self
    
    madalNavigationController = UINavigationController(rootViewController: modal)
    if let madalNavigationController {
      madalNavigationController.modalPresentationStyle = .pageSheet
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
    if let vc = navigationController.viewControllers.last as? FeedMainController {
      vc.refreshRecentFeeds(postId: postId)
    }
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

extension FeedMainCoordinator: FeedReportModalControllerDelegate {
  func dismissModal() {
    navigationController.dismiss(animated: true)
  }
  
  func successReport(userId: Int) {
    navigationController.dismiss(animated: true)
//    if let vc = navigationController.viewControllers.last as? FeedMainController {
//      vc.removeReportedFeed(userId: userId)
//    }
  }
}
