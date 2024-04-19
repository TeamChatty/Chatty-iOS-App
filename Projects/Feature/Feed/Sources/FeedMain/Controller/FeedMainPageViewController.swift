//
//  FeedMainPageViewController.swift
//  FeatureFeed
//
//  Created by 윤지호 on 4/15/24.
//

import UIKit
import SharedDesignSystem

import SnapKit
import RxSwift
import RxCocoa
import DomainCommunityInterface


final class FeedMainPageViewController: UIPageViewController {
  private let dataViewControllers: [UIViewController] = {
    let lastestVC = FeedTypeTableView(reactor: FeedTypeTableReactor(feedType: .lastest))
    let recommendVC = FeedTypeTableView(reactor: FeedTypeTableReactor(feedType: .recommend))
    
    return [lastestVC, recommendVC]
  }()
  
  private var nowPageIndex: Int = 0
  
  override init(transitionStyle style: UIPageViewController.TransitionStyle,
                navigationOrientation: UIPageViewController.NavigationOrientation,
                options: [UIPageViewController.OptionsKey: Any]? = nil) {
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
  }
  
  var touchEventRelay: PublishRelay<TouchEventType> = .init()
  private let disposeBag = DisposeBag()
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bind()
  }
  
  // MARK: - UIConfigurable
  private func configureUI() {
    reloadPageView()
  }
  
  // MARK: - UIBindable
  private func bind() {
    self.dataViewControllers.forEach { vc in
//      guard let vc = vc as? ProfileEditMainPageTypeViewController else {
//        return
//      }
//      
//      vc.touchEventRelay
//        .map { event in
//
//          }
//        }
//        .bind(to: touchEventRelay)
//        .disposed(by: disposeBag)
    }
  }
}

extension FeedMainPageViewController {
  enum TouchEventType {
    case changePage(Int)
    
  }
}

extension FeedMainPageViewController: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    let previousIndex = nowPageIndex - 1
    if previousIndex < 0 {
        return nil
    } else {
        return dataViewControllers[previousIndex]
    }
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    let nextIndex = nowPageIndex + 1
    if nextIndex >= dataViewControllers.count {
        return nil
    } else {
        return dataViewControllers[nextIndex]
    }
  }
}

extension FeedMainPageViewController: UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed {
      let index = nowPageIndex == 0 ? 1 : 0
      touchEventRelay.accept(.changePage(index))
    }
  }
  
  func setPageIndex(_ index: Int) {
    if index >= 0 && index < self.dataViewControllers.count {
      if nowPageIndex < index {
        self.setViewControllers([self.dataViewControllers[index]], direction: .forward, animated: true, completion: nil)
      } else {
        self.setViewControllers([self.dataViewControllers[index]], direction: .reverse, animated: true, completion: nil)
      }
    }
    nowPageIndex = index
  }
  
  private func reloadPageView() {
      delegate = nil
      dataSource = nil
      delegate = self
      dataSource = self
      
      if let firstVC = dataViewControllers.first {
          self.setViewControllers([firstVC], direction: .forward, animated: true)
      }
  }
}

