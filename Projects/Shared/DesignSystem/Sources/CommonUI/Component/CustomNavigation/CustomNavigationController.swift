//
//  CustomNavigationController.swift
//  SharedDesignSystem
//
//  Created by walkerhilla on 12/30/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

/// `CustomNavigationController`는 NavigationController에서 공통적으로 처리하는 로직의 인터페이스를 정의해요.
///
/// __Method__
/// - `configureUI`: UI과 관련된 설정을 적용하는 메소드에요.
///   이 메소드는 컨트롤러의 UI를 설정하는데 사용되고, viewDidLoad 시점에 실행돼요.
///
public final class CustomNavigationController: UINavigationController, Bindable, UINavigationControllerDelegate {
  // MARK: - View Property
  private var customNavigationBarConfigStack: [any CustomNavigationBarConfigurable] = []
  
  private let customNavigationBarBackgroundView: UIView = UIView()
  
  private var customNavigationBar: CustomNavigationBar = CustomNavigationBar()
  
  public var customNavigationBarGuide: ConstraintViewDSL {
    return customNavigationBar.snp
  }
  
  public var customNavigationBarConfig: (any CustomNavigationBarConfigurable)? = nil {
    willSet {
      guard let newValue else { return }
      if !customNavigationBarConfigStack.contains(where: { $0.identifier == newValue.identifier }) {
        customNavigationBarConfigStack.append(newValue)
      }
      setCustomNavigationBar(newValue)
    }
  }
  
  // MARK: - Life Method
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    setupBackgroundIfNotSet()
  }
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  private let navigationBarRightButtonsRelay: PublishRelay<Int> = .init()
  
  // MARK: - CustomNavigation Delegate
  public weak var customDelegate: CustomNavigationDelegate?
  
  // MARK: - Initialize Method
  public init() {
    super.init(nibName: nil, bundle: nil)
    delegate = self
    bind()
  }
  
  @available(*, unavailable)
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UIConfigurable
  public func configureUI() {
    disableDefaultNavigationBar()
  }
  
  // MARK: - Navigation Delegate
  public override func popViewController(animated: Bool) -> UIViewController? {
    let vc = super.popViewController(animated: animated)
    let _ = customNavigationBarConfigStack.popLast()
    if let config = customNavigationBarConfigStack.last {
      setCustomNavigationBar(config)
      setCustomNavigationBarHidden(false, animated: true)
    }
    setBackButton(viewControllers)
    return vc
  }
  
  public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    super.pushViewController(viewController, animated: animated)
    setBackButton(viewControllers)
    customDelegate?.pushViewController()
  }
  
  public override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
    super.setViewControllers(viewControllers, animated: animated)
    setBackButton(viewControllers)
  }
}

extension CustomNavigationController {
  public func bind() {
    customNavigationBar.touchEventRelay
      .bind(with: self) { owner, touch in
        switch touch {
        case .back(let closure):
          guard let closure else {
            let _ = owner.popViewController(animated: true)
            owner.customDelegate?.popViewController()
            return
          }
          closure()
        case .rightButtons(let button):
          owner.navigationBarRightButtonsRelay.accept(button.rawValue)
          print("aaaa ==>")
        }
      }
      .disposed(by: disposeBag)
  }
  
  public func navigationBarEvents<T: IntCaseIterable>(of enumType: T.Type) -> PublishRelay<T> {
    let relay = PublishRelay<T>()
    
    navigationBarRightButtonsRelay
      .compactMap { enumType.init(rawValue: $0) }
      .bind(to: relay)
      .disposed(by: disposeBag)
    
    return relay
  }
  
  public func setCustomNavigationBarHidden(_ hidden: Bool, animated: Bool) {
    if hidden {
      if animated {
        customNavigationBar.fadeOut([customNavigationBar], alpha: .transparent) { [weak self] in
          self?.customNavigationBarBackgroundView.removeFromSuperview()
          self?.customNavigationBar.removeFromSuperview()
        }
      } else {
        customNavigationBarBackgroundView.removeFromSuperview()
        customNavigationBar.removeFromSuperview()
      }
    } else {
      setupCustomNavigationBar()
      if animated {
        customNavigationBar.fadeIn([customNavigationBar], alpha: .full)
      }
    }
  }
  
  private func setupCustomNavigationBar() {
    if customNavigationBar.superview == nil {
//      view.addSubview(customNavigationBarBackgroundView)
      view.addSubview(customNavigationBar)
      
//      customNavigationBarBackgroundView.snp.makeConstraints {
//        $0.top.equalToSuperview()
//        $0.horizontalEdges.equalToSuperview()
//        $0.height.equalTo(50)
//      }
      
      customNavigationBar.snp.makeConstraints {
        $0.top.equalTo(self.view.safeAreaLayoutGuide)
        $0.leading.trailing.equalToSuperview()
        $0.height.equalTo(52)
      }
    }
  }
  
  private func setCustomNavigationBar(_ config: any CustomNavigationBarConfigurable) {
    setupCustomNavigationBar()
    customNavigationBar.setNavigationBar(with: config)
  }
  
  private func setBackButton(_ viewControllers: [UIViewController]) {
    // 자식 뷰 컨트롤러가 2개 이상일 경우
    guard viewControllers.count > 1 else {
      customNavigationBar.backButton = nil
      return
    }
    
    // 네비게이션 바의 백 버튼이 설정되지 않은 경우
    guard customNavigationBar.backButton == nil else { return }
    
    let button = CustomNavigationBarButton(image: UIImage(asset: Images.vArrowLeft)!)
    customNavigationBar.backButton = button
  }
  
  private func setupBackgroundIfNotSet() {
    if self.view.backgroundColor == nil {
      self.view.backgroundColor = SystemColor.basicWhite.uiColor
    }
  }
  
  private func disableDefaultNavigationBar() {
    setNavigationBarHidden(true, animated: false)
  }
}

public protocol CustomNavigationDelegate: AnyObject {
  func popViewController()
  func pushViewController()
}
