//
//  ProfileEditMainPageViewController.swift
//  FeatureProfileInterface
//
//  Created by 윤지호 on 3/22/24.
//

import UIKit
import SharedDesignSystem

import SnapKit
import RxSwift
import RxCocoa
import DomainUserInterface

final class ProfileEditMainPageViewController: UIPageViewController {
  private let dataViewControllers: [UIViewController] = {
    let editVC = ProfileEditMainPageTypeViewController(pageType: .edit)
    let previewVC = ProfileEditMainPageTypeViewController(pageType: .preview)
    
    return [editVC, previewVC]
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
      guard let vc = vc as? ProfileEditMainPageTypeViewController else {
        return
      }
      
      vc.touchEventRelay
        .map { event in
          switch event {
          case .chatImageGuide:
            return TouchEventType.chatImageGuide
          case .imageGuide:
            return TouchEventType.imageGuide
          case .selectImage:
            return TouchEventType.selectImage
          case .nickname:
            return TouchEventType.nickname
          case .address:
            return TouchEventType.address
          case .job:
            return TouchEventType.job
          case .school:
            return TouchEventType.school
          case .introduce:
            return TouchEventType.introduce
          case .mbti:
            return TouchEventType.mbti
          case .interests:
            return TouchEventType.interests
        
          }
        }
        .bind(to: touchEventRelay)
        .disposed(by: disposeBag)
    }
  }
}

extension ProfileEditMainPageViewController {
  enum TouchEventType {
    case changePage(Int)
    
    case chatImageGuide
    case imageGuide
    case selectImage
    
    case nickname
    case address
    case job
    case school
    
    case introduce
    case mbti
    case interests
  }
}

extension ProfileEditMainPageViewController: UIPageViewControllerDataSource {
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

extension ProfileEditMainPageViewController: UIPageViewControllerDelegate {
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

extension ProfileEditMainPageViewController {
  func setUserData(userData: UserProfile) {
    self.viewControllers?.forEach { viewController in
      guard let vc = viewController as? ProfileEditMainPageTypeViewController else { return }
      vc.updateUserProfile(userProfile: userData)
    }
  }
}
