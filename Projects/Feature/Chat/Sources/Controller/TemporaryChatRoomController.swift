//
//  TemporaryChatRoomController.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 17.04.2024.
//

import UIKit
import ReactorKit
import SharedDesignSystem

public final class TemporaryChatRoomController: BaseController {
  private let mainView = TemporaryChatRoomView()
  private lazy var chatAdapter = ChatRoomCollectionViewAdapter(collectionView: mainView.collectionView, chatRoomType: .temporary(creationTime: nil))
  
  public typealias Reactor = ChatReactor
  public var temporaryChatReactor: TemporaryChatReactor
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    if let roomCreatedTime = reactor?.roomViewData.createdTime {
      print("타이머 돌릴게~")
      temporaryChatReactor.startTimer(from: roomCreatedTime)
    }
    customNavigationController?.setCustomNavigationBarHidden(true, animated: false)
  }
  
  required init(reactor: Reactor, temporaryChatReactor: TemporaryChatReactor) {
    self.temporaryChatReactor = temporaryChatReactor
    super.init()
    self.reactor = reactor
  }
  
  
  public override func handleAppInactive() {
    temporaryChatReactor.stopTimer()
  }
  
  public override func handleAppActive() {
    print("타이머 시도")
    if let roomCreatedTime = reactor?.roomViewData.createdTime {
      print("타이머 돌릴게~")
      temporaryChatReactor.startTimer(from: roomCreatedTime)
    }
  }
  
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    print("화면 사라진다")
  }
  
  public override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    print("화면 사라진다")
  }
  
  public override func configureUI() {
    view.addSubview(mainView)
    mainView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.horizontalEdges.bottom.equalToSuperview()
    }
  }
}

extension TemporaryChatRoomController: ReactorKit.View {
  public func bind(reactor: ChatReactor) {
    temporaryChatReactor.state
      .map (\.timeInterval)
      .bind(with: self) { owner, timeInterval in
        guard let timeInterval else { return }
      }
      .disposed(by: disposeBag)
    
    rx.viewDidLoad
      .map { _ in .connectChatServer }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    if let date = reactor.roomViewData.createdTime {
      rx.viewDidLoad
        .map { _ in .runTimer(date) }
        .bind(to: temporaryChatReactor.action)
        .disposed(by: disposeBag)
    }
    
    reactor.state
      .map(\.socketState)
      .distinctUntilChanged()
      .bind(with: self) { owner, state in
        guard let state else { return }
        switch state {
        case .socketConnected:
          print("STOMP 소켓 연결됨~")
          break
        case .stompConnected:
          print("STOMP 스톰프 연결됨~")
          reactor.action.onNext(.observeChatMessage)
          reactor.action.onNext(.subscribeToChatRoom(roomId: reactor.roomViewData.roomId))
        case .stompDisconnected:
          print("STOMP 연결해제 됨")
          reactor.action.onNext(.connectChatServer)
        }
      }
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
        case .close:
          let _ = owner.customNavigationController?.popViewController(animated: true)
        case .report:
          print("신고")
        }
      }
      .disposed(by: disposeBag)
  }
}
