//
//  LiveController.swift
//  FeatureLive
//
//  Created by walkerhilla on 12/26/23.
//

import UIKit
import SharedDesignSystem

import SnapKit
import RxSwift
import RxCocoa
import ReactorKit

final class LiveMainController: BaseController {
  // MARK: - View Property
  private let backgroundImageView: UIImageView = UIImageView().then {
    $0.image = Images.matchHomeBackimage.image
    $0.backgroundColor = .white
    $0.contentMode = .scaleAspectFit
  }
  private let mainView = LiveMainView()
  
  
  // MARK: - Reactor Property
  typealias Reactor = LiveMainReactor
  
  // MARK: - Delegate
  weak var delegate: LiveMainControllerDelegate? {
    didSet {
      print("LiveMainControllerDelegate")
    }
  }
  
  // MARK: - Life Method
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Initialize Method
  required init(reactor: Reactor) {
    defer {
      self.reactor = reactor
    }
    super.init()
  }
  
  deinit {
    print("해제됨: LiveMainController")
  }
  
   // MARK: - UIConfigurable
  override func configureUI() {
    setView()
  }
  
  override func setNavigationBar() {
    super.setNavigationBar()
    let titleView = CustomNavigationBarItem(title: "실시간")
    let bellButton = CustomNavigationBarButton(image: Images.bell.image)
    
    customNavigationController?.customNavigationBarConfig = CustomNavigationBarConfiguration(
      titleView: titleView,
      titleAlignment: .leading,
      rightButtons: [bellButton]
    )
    customNavigationController?.navigationBarEvents(of: BarTouchEvent.self)
      .bind(with: self) { owner, event in
        switch event {
        case .notification:
          print("push noti")
        }
      }
      .disposed(by: disposeBag)
  }
  
  enum BarTouchEvent: Int, IntCaseIterable {
    case notification
  }
}

extension LiveMainController: ReactorKit.View {
  func bind(reactor: LiveMainReactor) {
    mainView.touchEventRelay
      .bind(with: self) { owner, event in
        switch event {
        case .membership:
          owner.delegate?.pushToCandyStore()
        case .cashItem:
          owner.delegate?.pushToCandyStore()
        case .genderCondition:
          owner.delegate?.presentEditGenderConditionModal(reactor.currentState.matchState)
        case .ageCondition:
          owner.delegate?.presentEditAgeConditionModal(reactor.currentState.matchState)
        case .talkButton:
          owner.delegate?.presentMatchModeModal(reactor.currentState.matchState)
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.matchState.gender)
      .distinctUntilChanged()
      .bind(with: self) { owner, gender in
        owner.mainView.setGender(gender)
      }
      .disposed(by: disposeBag)
  }
}

extension LiveMainController {
  private func setView() {
    self.view.addSubview(backgroundImageView)
    backgroundImageView.snp.makeConstraints {
      $0.horizontalEdges.verticalEdges.equalToSuperview()
    }
    
    
    self.view.addSubview(mainView)
    mainView.snp.makeConstraints {
      $0.horizontalEdges.verticalEdges.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
}
