//
//  CustomNavigationBar.swift
//  SharedDesignSystem
//
//  Created by walkerhilla on 1/2/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

public class CustomNavigationBar: BaseView, Touchable, Fadeable {
  public lazy var identifier: UUID = UUID()
  
  // MARK: - View Property
  public lazy var backButton: CustomNavigationBarButton? = nil {
    didSet {
      fadeOutView([oldValue])
      setBackButton(backButton)
      fadeInView([backButton])
    }
  }
  
  public var backButtonClosure: (() -> Void)?
  
  public lazy var titleView: CustomNavigationBarItem? = nil {
    didSet {
      fadeOutView([oldValue])
      setTitleView(titleView, alignment: titleAlignment)
      fadeInView([titleView])
    }
  }
  
  public var titleAlignment: TitleAlignment = .center
  
  public lazy var rightButtons: [CustomNavigationBarButton] = [] {
    didSet {
      fadeOutView(oldValue)
      setRightButtons(rightButtons)
      fadeInView(rightButtons)
    }
  }
  
  private let rightButtonStackView: UIStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 16
    $0.alignment = .fill
    $0.distribution = .equalSpacing
  }
  
  // MARK: - Touchable
  public var touchEventRelay: PublishRelay<TouchEventType> = .init()
  
  // MARK: - Rx Property
  private var disposeBag = DisposeBag()
  
  open override func configureUI() {
    setRightButtonStackView()
  }
  
  private func setBackButton(_ backButton: CustomNavigationBarButton?) {
    guard let backButton else { return }
    disposeBag = DisposeBag()
    addSubview(backButton)
    backButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(24)
    }
    
    backButton.rx.controlEvent(.touchUpInside)
      .withUnretained(self)
      .map { [weak self] _ in
        return .back(self?.backButtonClosure)
      }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
  
  private func setTitleView(_ titleView: CustomNavigationBarItem?, alignment: TitleAlignment) {
    guard let titleView else { return }
    addSubview(titleView)
    
    switch alignment {
    case .center:
      titleView.snp.makeConstraints {
        $0.center.equalToSuperview()
      }
    case .leading:
      titleView.snp.makeConstraints {
        $0.leading.equalToSuperview().offset(20)
        $0.centerY.equalToSuperview()
      }
    }
  }
  
  private func setRightButtons(_ rightButton: [CustomNavigationBarButton]) {
    
    rightButtonStackView.removeAllArrangedSubViews()
    rightButton.enumerated().forEach { [weak self] index, item in
      guard let self else { return }
      self.rightButtonStackView.addArrangedSubview(item)
      
      item.touchEventRelay
        .withUnretained(self)
        .map { _ in
            return .rightButtons(.allCases[index])
        }
        .bind(to: self.touchEventRelay)
        .disposed(by: disposeBag)
    }
  }
  
  private func setRightButtonStackView() {
    addSubview(rightButtonStackView)
    rightButtonStackView.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalToSuperview()
      $0.height.equalTo(24)
    }
  }
  
  private func fadeOutView(_ views: [UIView?]) {
    self.fadeOut(views, duration: .fast, alpha: .transparent) {
      views.forEach {
        $0?.removeFromSuperview()
      }
    }
  }
  
  private func fadeInView(_ views: [UIView?]) {
    views.forEach {
      $0?.alpha = 0
    }
    self.fadeIn(views, duration: .normal, alpha: .full)
  }
}

extension CustomNavigationBar {
  public enum TouchEventType {
    case back((() -> Void)?)
    case rightButtons(RightButton)
  }
  
  public enum RightButton: Int, CaseIterable {
    case button1, button2, button3, button4
  }
  
  public enum TitleAlignment {
    case center
    case leading
  }
  
  func setNavigationBar(with config: any CustomNavigationBarConfigurable) {
    self.titleAlignment = config.titleAlignment
    self.titleView = config.titleView
    self.rightButtons = config.rightButtons
    self.backButtonClosure = config.backButtonClosure
  }
}
