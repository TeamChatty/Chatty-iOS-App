//
//  ChangeableImageButton.swift
//  SharedDesignSystem
//
//  Created by 윤지호 on 1/12/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit

public final class ChangeableImageButton: UIControl, Touchable, Highlightable {
  // MARK: - View Property
  private let imageView: UIImageView = UIImageView()
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  public let touchEventRelay: PublishRelay<Void> = .init()
  
  // MARK: - StateConfigurable Property
  public var configurations: [State : Configuration] = [:]
  public var currentState: State? {
    didSet {
      updateForCurrentState()
    }
  }
  
  // MARK: - Initalize Method
  public override init(frame: CGRect) {
    super.init(frame: frame)
    bind()
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension ChangeableImageButton {
  private func bind() {
    self.rx.controlEvent(.touchDown)
      .bind(with: self) { owner, _ in
        owner.highlight(owner)
      }
      .disposed(by: disposeBag)
    
    Observable.merge(
      self.rx.controlEvent(.touchDragExit).map { _ in Void() },
      self.rx.controlEvent(.touchCancel).map { _ in Void() }
    )
    .bind(with: self) { owner, _ in
      owner.unhighlight(owner)
    }
    .disposed(by: disposeBag)
    
    self.rx.controlEvent(.touchUpInside)
      .map { _ in Void() }
      .withUnretained(self)
      .do { owner, _ in
        self.unhighlight(owner)
      }
      .map { _ in Void() }
      .bind(to: touchEventRelay)
      .disposed(by: disposeBag)
  }
  
  private func configureUI() {
    addSubview(imageView)
    imageView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
}

extension ChangeableImageButton: StateConfigurable {
  public enum State {
    case enabled
    case disabled
    case systemImage
    case customImage
  }
  
  public struct Configuration {
    var image: UIImage
    let tintColor: UIColor
    let size: Double
    let isEnabled: Bool
    let backgroundColor: UIColor
    
    public init(image: UIImage, tintColor: UIColor = .clear, backgroundColor: UIColor = .clear, size: Double = 0, isEnabled: Bool) {
      self.image = image
      self.tintColor = tintColor
      self.size = size
      self.isEnabled = isEnabled
      self.backgroundColor = backgroundColor
    }
  }
  
  public func updateForCurrentState() {
    guard let currentState,
          let config = configurations[currentState] else { return }
    
    backgroundColor = config.backgroundColor
    imageView.tintColor = SystemColor.gray300.uiColor
    imageView.image = config.image
    
    var image = UIImage()
    
    switch currentState {
    case .enabled, .disabled, .customImage:
      if config.size == 0 {
        imageView.contentMode = .scaleAspectFill
        image = config.image
      } else {
        imageView.contentMode = .center
        image = config.image.resize(newWidth: config.size).withRenderingMode(.alwaysTemplate)
      }
      
    case .systemImage:
      imageView.contentMode = .center
      let symbolConfig = UIImage.SymbolConfiguration(pointSize: config.size)
      let systemImage = config.image.withConfiguration(symbolConfig)
      image = systemImage
    }
    
    imageView.tintColor = config.tintColor
    imageView.image = image
    
    isEnabled = config.isEnabled
  }
  
  public func updateStateConfigure(_ state: State, image: UIImage) {
    configurations[state]?.image = image
  }
}
