//
//  MainTabBarController.swift
//  Feature
//
//  Created by walkerhilla on 12/26/23.
//

import UIKit
import SharedDesignSystem

public final class MainTabBarController: UITabBarController {
  private var tabNavigationControllers: [MainTabBarItemType: CustomNavigationController]
  
  init(tabNavigationControllers: [MainTabBarItemType : CustomNavigationController]) {
    self.tabNavigationControllers = tabNavigationControllers
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    print("해제됨: MainTabBarController")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTabBarController(controllers: tabNavigationControllers)
    navigationController?.navigationBar.isHidden = true
  }
  
  private func configureTabBarController(controllers: [MainTabBarItemType: CustomNavigationController]) {
    self.tabBar.tintColor = SystemColor.primaryNormal.uiColor
    
    let items = MainTabBarItemType.allCases.map { item -> CustomNavigationController in
      guard let tab = tabNavigationControllers[item] else { return CustomNavigationController() }
      if let defaultImage = UIImage(asset: item.tabIconDefault),
        let selectedImage = UIImage(asset: item.tabIconSelected) {
        tab.tabBarItem.image = defaultImage
        tab.tabBarItem.selectedImage = selectedImage
      }
      tab.tabBarItem.title = item.title
      return tab
    }
    
    viewControllers = items
  }
  
  func removeTabControllers() {
    tabNavigationControllers[MainTabBarItemType.chat]?.navigationController?.viewControllers.removeAll()
    tabNavigationControllers.removeAll()
    self.viewControllers?.removeAll()
  }
}
