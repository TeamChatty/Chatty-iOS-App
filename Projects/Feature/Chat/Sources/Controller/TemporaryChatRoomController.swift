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
      temporaryChatReactor.action.onNext(.runTimer(roomCreatedTime))
    }
  }
  
  public override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    customNavigationController?.setCustomNavigationBarHidden(true, animated: false)
  }
  
  required init(reactor: Reactor, temporaryChatReactor: TemporaryChatReactor) {
    self.temporaryChatReactor = temporaryChatReactor
    super.init()
    self.reactor = reactor
  }
  
  deinit {
    print("deinit - TemporaryChatRoomController")
  }
  
  public override func handleAppInactive() {
    temporaryChatReactor.action.onNext(.stopTimer)
  }
  
  public override func handleAppActive() {
    print("타이머 시도")
    if let roomCreatedTime = reactor?.roomViewData.createdTime {
      print("타이머 돌릴게~")
      temporaryChatReactor.action.onNext(.runTimer(roomCreatedTime))
    }
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
    print("바인드 실행됩니다.")
    reactor.state
      .map(\.partnerProfile)
      .bind(with: self) { owner, profile in
        guard let profile else { return }
        print("프로필 조회")
        owner.mainView.chatRoomHeaderBar.profileData.onNext(profile)
      }
      .disposed(by: disposeBag)
    
    temporaryChatReactor.state
      .map (\.timeString)
      .bind(with: self) { owner, timeString in
        owner.mainView.updateTimeLabel(timeString)
      }
      .disposed(by: disposeBag)
    
    temporaryChatReactor.state
      .map (\.chatRoomStatus)
      .distinctUntilChanged()
      .bind(with: self) { owner, state in
        let bottomSheetView = ChatRoomActivationSheetView().then {
          $0.title = "1분 남았어요. 채팅을 연장할까요?"
          $0.subTitle = "무제한으로 소통하는 채팅방이 만들어져요."
        }
        let bottomSheetController = CustomBottomSheetController(contentView: bottomSheetView)
        owner.present(bottomSheetController, animated: false)
      }
      .disposed(by: disposeBag)
    
    rx.viewIsAppear
      .map { _ in .connectChatServer }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    rx.viewIsAppear
      .map { _ in .getPartnerProfile(userId: reactor.roomViewData.recieverProfile.userId) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
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
