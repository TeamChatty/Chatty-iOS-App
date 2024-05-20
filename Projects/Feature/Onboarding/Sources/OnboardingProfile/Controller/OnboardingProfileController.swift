//
//  OnboardingProfileController.swift
//  FeatureOnboardingInterface
//
//  Created by 윤지호 on 12/31/23.
//

import UIKit
import ReactorKit
import RxSwift
import SharedDesignSystem

public protocol OnboardingProfileDelegate: AnyObject {
  func pushToNextView(_ state: OnboardingProfileReactor.State)
  func presentImageGuideModal()
  func switchToMainTab()
}

public final class OnboardingProfileController: BaseController {
  // MARK: - View
  private let profileView: OnboardingProfileView = OnboardingProfileView()
  
  // MARK: - Reactor Property
  public typealias Reactor = OnboardingProfileReactor
  
  // MARK: - Life Method
  public override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    reactor?.action.onNext(.viewDidLoad)
  }
  
  // MARK: - Initialize Method
  required init(reactor: Reactor) {
    defer {
      self.reactor = reactor
    }
    super.init()
  }
  
  public weak var delegate: OnboardingProfileDelegate?
  
  // MARK: - UIConfigurable
  public override func configureUI() {
    view.addSubview(profileView)
    profileView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(52)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  deinit {
    self.delegate = nil
    print("해제됨: ProfileController - delegate \(delegate == nil) ")
  }
  
  public override func setNavigationBar() {
    super.setNavigationBar()
    if reactor?.currentState.viewState == .profileImage {
      customNavigationController?.customNavigationBarConfig = CustomNavigationBarConfiguration(
        rightButtons: [.init(title: "건너뛰기")]
      )
      customNavigationController?.navigationBarEvents(of: BarTouchEvent.self)
        .bind(with: self) { owner, event in
          switch event {
          case .skipImage:
            owner.delegate?.pushToNextView(owner.reactor!.currentState)
          }
        }
        .disposed(by: disposeBag)
    }
  }
  
  enum BarTouchEvent: Int, IntCaseIterable {
    case skipImage
  }
}

extension OnboardingProfileController: ReactorKit.View {
  public func bind(reactor: OnboardingProfileReactor) {
    
    profileView.touchEventRelay
      .bind(with: self) { owner, touch in
        switch touch {
        case .tabGender(let gender):
          owner.reactor?.action.onNext(.toggleGender(gender))
        case .setBirth(let date):
          owner.reactor?.action.onNext(.selectBirth(date))
        case .continueButton:
          owner.reactor?.action.onNext(.tabContinueButton)
        case .tabImagePicker:
          owner.reactor?.action.onNext(.tabImagePicker)
        case .tabTag(let tag):
          owner.reactor?.action.onNext(.tabTag(tag))
        case .toggleMBTI(let mbti, let state):
          owner.reactor?.action.onNext(.toggleMBTI(mbti, state))
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.isSuccessSave)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, result in
        if result {
          let nextType = reactor.currentState.viewState.nextViewType
          if nextType != .none {
            owner.delegate?.pushToNextView(reactor.currentState)
            owner.reactor?.action.onNext(.didPushed)
          } else {
            owner.delegate?.switchToMainTab()
          }
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.viewState)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, type in
        owner.profileView.updateTitleTextView(type, nickName: reactor.currentState.profileData.nickName)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.isContinueEnabled)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, state in
        owner.profileView.updateContinuBtn(state)
      }
      .disposed(by: disposeBag)
    
    // Gender
    reactor.state
      .map(\.profileData.gender)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, gender in
        owner.profileView.setGender(gender)
      }
      .disposed(by: disposeBag)
    
    // Image
    reactor.state
      .map(\.isPickingImage)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, result in
        if result {
          owner.delegate?.presentImageGuideModal()
          owner.reactor?.action.onNext(.didPushed)
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.profileData.porfileImage)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, image in
        owner.profileView.updateProfileImageView(image)
      }
      .disposed(by: disposeBag)
    
    // Interest Tag
    reactor.state
      .map(\.Allinterests)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, tags in
        owner.profileView.updateInterestCollectionView(tags)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.profileData.interest)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, tags in
        owner.profileView.updateInterestCollectionCell(tags)
      }
      .disposed(by: disposeBag)
    
    // MBTI
    reactor.state
      .map(\.profileData.mbti)
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, mbti in
        owner.profileView.updateMBTIView(mbti)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.errorState)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, error in
        switch error {
        case .refreshTokenExpired:
          print("refreshTokenExpired")
        default:
          return
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map(\.isLoading)
      .distinctUntilChanged()
      .observe(on: MainScheduler.asyncInstance)
      .bind(with: self) { owner, isLoading in
        if isLoading {
          owner.showLoadingIndicactor()
        } else {
          owner.hideLoadingIndicator()
        }
      }
      .disposed(by: disposeBag)
  }
}

