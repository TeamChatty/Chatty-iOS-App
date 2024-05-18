//
//  NotificationCenterController.swift
//  FeatureProfileInterface
//
//  Created by HUNHIE LEE on 2.05.2024.
//

import Foundation
import SharedDesignSystem

import RxSwift
import RxCocoa
import ReactorKit

public final class NotificationCenterController: BaseController {
  private let mainView = NotificationCenterView()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    let data: [Notificationitem] = [
      .init(type: .chat, title: "누군가 채팅을 보냈어요", createdDate: Date(), isRead: false),
      .init(type: .feed, title: "누군가 채팅을 보냈어요", createdDate: Date(), isRead: true),
      .init(type: .feed, title: "누군가 채팅을 보냈어요", createdDate: Date(), isRead: true),
      .init(type: .marketing, title: "누군가 채팅을 보냈어요", createdDate: Date(), isRead: true)
    ]
    
    mainView.applySnapShot(items: data)
  }
  
  public override func setNavigationBar() {
    super.setNavigationBar()
    
    self.customNavigationController?.customNavigationBarConfig = CustomNavigationBarConfiguration(
      titleView: .init(title: "알림"),
      rightButtons: [
      .init(title: "모두읽음")
      ],
      backgroundColor: SystemColor.basicWhite.uiColor
    )
    
    customNavigationController?.navigationBarEvents(of: BarTouchEvent.self)
      .subscribe(with: self, onNext: { owner, event in
        switch event {
        case .readAll:
          print("READ ALL")
        }
      })
      .disposed(by: disposeBag)
  }
  
  enum BarTouchEvent: Int, IntCaseIterable {
    case readAll
  }
  
  public override func configureUI() {
    super.configureUI()
    
    view.addSubview(mainView)
    if let navigationBarGuide = customNavigationController?.customNavigationBarGuide {
      mainView.snp.makeConstraints {
        $0.top.equalTo(navigationBarGuide.bottom)
        $0.horizontalEdges.equalToSuperview()
        $0.bottom.equalTo(view.safeAreaLayoutGuide)
      }
    } else {
      mainView.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }
  }
}
