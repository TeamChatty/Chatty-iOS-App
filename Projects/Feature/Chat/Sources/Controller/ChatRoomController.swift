//
//  ChatRoomController.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 2/9/24.
//

import UIKit
import ReactorKit
import SharedDesignSystem

public final class ChatRoomController: BaseController {
  private let mainView = ChatRoomView()
  private lazy var chatAdapter = ChatRoomCollectionViewAdapter(collectionView: mainView.collectionView, chatRoomType: .unlimited)
  
  public typealias Reactor = ChatReactor
  
  public override func loadView() {
    view = mainView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    mainView.chatRoomType = reactor?.roomViewData.chatRoomActiveStatus
  }
  
  required init(reactor: Reactor) {
    defer {
      self.reactor = reactor
    }
    super.init()
  }
  
  public override func setNavigationBar() {
    guard let title = reactor?.roomViewData.recieverProfile.name else { return }
    self.customNavigationController?.customNavigationBarConfig = CustomNavigationBarConfiguration(
      titleView: .init(title: title),
      rightButtons: [.init(image: UIImage(asset: Images._3DotHorizontal)!)],
      backgroundColor: SystemColor.basicWhite.uiColor,
      backgroundAlpha: 0.97
    )
    
    customNavigationController?.navigationBarEvents(of: BarTouchEvent.self)
      .subscribe(with: self) { owner, event in
        switch event {
        case .notification:
          let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
          let declaration = UIAlertAction(title: "신고하기", style: .default) { action in
            
          }
          let block = UIAlertAction(title: "차단하기", style: .default) { action in
            
          }
          let cancel = UIAlertAction(title: "취소", style: .cancel)
          
          alert.addAction(declaration)
          alert.addAction(block)
          alert.addAction(cancel)
          
          owner.present(alert, animated: true)
        }
      }
      .disposed(by: disposeBag)
  }
  
  enum BarTouchEvent: Int, IntCaseIterable {
    case notification
  }
}

extension ChatRoomController: ReactorKit.View {
  public func bind(reactor: Reactor) {
    self.rx.viewDidLoad
      .map { .loadMessages }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    self.rx.viewIsAppear
      .map { _ in .observeChatMessage }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    self.rx.viewDidAppear
      .map { _ in .scrollToUnreadMessage }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    mainView.inputEventRelay
      .map { .sendMessage($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.messages)
      .subscribe(with: self) { owner, messages in
        owner.chatAdapter.applySnapshot(messages: messages.0, animatingDifferences: messages.1)
      }
      .disposed(by: disposeBag)
    
    mainView.touchEventRelay
      .subscribe(with: self) { owner, touchEvent in
        switch touchEvent {
        case .chatRoomIsNotActive:
          let bottomSheetView = ChatRoomActivationSheetView().then {
            $0.title = "채팅 연장하기"
            $0.subTitle = "무제한으로 소통하는 채팅방이 만들어져요."
          }
          let bottomSheetController = CustomBottomSheetController(contentView: bottomSheetView)
          owner.present(bottomSheetController, animated: false)
        }
      }
      .disposed(by: disposeBag)
  }
}
