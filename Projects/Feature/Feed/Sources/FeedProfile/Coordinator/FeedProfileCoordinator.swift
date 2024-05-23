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
import DomainChatInterface

import RxSwift

public final class FeedProfileCoordinator: BaseCoordinator, FeedMainCoordinatorProtocol {
  public override var type: CoordinatorType {
    .feed(.profile)
  }
  
  private var madalNavigationController: UINavigationController?
  
  private let featureFeedDependencyProvider: FeatureFeedDependencyProvider

  public init(navigationController: CustomNavigationController, featureFeedDependencyProvider: FeatureFeedDependencyProvider) {
    self.featureFeedDependencyProvider = featureFeedDependencyProvider
    super.init(navigationController: navigationController)
  }
  
  let disposeBag = DisposeBag()
  
  public override func start() {
    let reactor = FeedProfileReactor()
    let myCommentVC = UIViewController()
    myCommentVC.view.backgroundColor = .brown
    let dataViewControllers: [UIViewController] = [
      FeedTypeTableView(reactor: FeedTypeTableReactor(
        getFeedsPageUseCase: featureFeedDependencyProvider.makeGetFeedsPageUseCase(),
        setBookmarkAndLikeUseCase: featureFeedDependencyProvider.makeSetBookmarkAndLikeUseCase(),
        reportUseCase: featureFeedDependencyProvider.makeReportUseCase(),
        feedType: .myPosts)),
      FeedMyCommentTableViewController(reactor: FeedMyCommentTableViewReactor(
        getMyCommentsUseCase: featureFeedDependencyProvider.makeGetMyCommentsUseCase(),
        setCommentLikeUseCase: featureFeedDependencyProvider.makeSetCommentLikeUseCase())),
      FeedTypeTableView(reactor: FeedTypeTableReactor(
        getFeedsPageUseCase: featureFeedDependencyProvider.makeGetFeedsPageUseCase(),
        setBookmarkAndLikeUseCase: featureFeedDependencyProvider.makeSetBookmarkAndLikeUseCase(),
        reportUseCase: featureFeedDependencyProvider.makeReportUseCase(),
        feedType: .myBookmark)),
    ]
    let feedProfilePageViewController = FeedProfilePageViewController(dataViewControllers: dataViewControllers)
    
    let feedProfileController = FeedProfileController(reactor: reactor, feedProfilePageViewController: feedProfilePageViewController)
    
    feedProfileController.delegate = self
    navigationController.pushViewController(feedProfileController, animated: true)
  }
}


extension FeedProfileCoordinator: FeedChatModalControllerDelegate {
  func startChatting(chatRoom: ChatRoom) {
    navigationController.dismiss(animated: true)
    
    /// Start Mehod
  }
}


extension FeedProfileCoordinator: FeedProfileControllerDelegate {
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
  
  func popToFeedMain() {
    _ = navigationController.popViewController(animated: true)
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

extension FeedProfileCoordinator: FeedReportModalControllerDelegate {
  func dismissModal() {
    navigationController.dismiss(animated: true)
  }
  
  func successReport(userId: Int) {
    navigationController.dismiss(animated: true)
//    if let vc = navigationController.viewControllers.last as? FeedProfileController {
//      vc.removeReportedFeed(userId: userId)
//    }
  }
}
