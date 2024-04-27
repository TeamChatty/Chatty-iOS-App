//
//  LiveMatchingController.swift
//  FeatureLive
//
//  Created by 윤지호 on 3/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ReactorKit
import SharedDesignSystem
import DomainLiveInterface
import DomainChatInterface

protocol LiveMatchingDelegate: AnyObject {
  func dismiss()
  func successMatching(room: ChatRoom)
}

final class LiveMatchingController: BaseController {
  // MARK: - View Property
  private let mainView = LiveMatchingView()
  
  // MARK: - Reactor Property
  typealias Reactor = LiveEditConditionModalReactor
  
  // MARK: - Delegate
  weak var delegate: LiveMatchingDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // MARK: - Life Method
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    reactor?.action.onNext(.matchingStart)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    reactor?.action.onNext(.matchingExit)
  }
  
  // MARK: - Initialize Method
  required init(reactor: Reactor) {
    defer {
      self.reactor = reactor
    }
    super.init()
  }
  
  // MARK: - UIConfigurable
  override func configureUI() {
    self.view = mainView
  }
  
  deinit {
    print("해제됨: LiveMatchingController")
  }
}

extension LiveMatchingController: ReactorKit.View {
  func bind(reactor: LiveEditConditionModalReactor) {
    mainView.touchEventRelay
      .bind(with: self) { owner, event in
        switch event {
        case .cancel:
          owner.delegate?.dismiss()
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.matchConditionState)
      .bind(with: self) { owner, condition in
        owner.mainView.setCondition(condition)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.matchingState)
      .bind(with: self) { owner, state in
        switch state {
        case .matching:
          print("matchingState - success match api")
        case .successMatching(let result):
          print("컨트롤러에서 매칭된 채팅방 받았음! \(result)")
          owner.delegate?.successMatching(room: result)
        default:
          print("do")
        }
        print(state)
        owner.mainView.setMatchingState(state)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.matchMode)
      .distinctUntilChanged()
      .bind(with: self) { owner, matchMode in
        owner.mainView.setMatchMode(matchMode)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.errorState)
      .distinctUntilChanged()
      .bind(with: self) { owner, error in
        switch error {
        /// 소켓 연결해제 시 매칭종료
        case .socketDisconnected:
          print("socketDisconnected")
          
        /// 소켓 연결오류 시 매칭종료
        case .socketSetupError:
          owner.showErrorAlert(
            title: "매칭 오류",
            subTitle: "연결에 문제가 생겼습니다. 다시 시도해주세요"
          )
          owner.delegate?.dismiss()
          
        /// refresh 토큰 만료 시 로그인 화면으로 전환
        case .socketTokenExpiration:
          print("socketTokenExpiration")
//          owner.delegate?.dismiss()
        
        case .unknownError:
          owner.showErrorAlert(
            title: "매칭 오류",
            subTitle: "연결에 문제가 생겼습니다. 다시 시도해주세요"
          )
//          owner.delegate?.dismiss()
          
        default:
          print("error none - \(String(describing: error))")
        }
      }
      .disposed(by: disposeBag)
    
  }
}
 
