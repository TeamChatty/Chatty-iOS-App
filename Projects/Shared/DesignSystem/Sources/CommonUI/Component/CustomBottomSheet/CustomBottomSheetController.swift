//
//  CustomBottomSheetController.swift
//  SharedDesignSystem
//
//  Created by HUNHIE LEE on 14.04.2024.
//

import UIKit
import Then
import SnapKit

open class CustomBottomSheetController: BaseController {
  public let contentView: CustomBottomSheetView
  
  private lazy var containerView: UIView = UIView().then {
    $0.backgroundColor = SystemColor.basicWhite.uiColor
    $0.setRoundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 20)
  }
  
  public init(contentView: CustomBottomSheetView) {
    self.contentView = contentView
    super.init()
    
    view.backgroundColor = .clear
    self.modalPresentationStyle = .overCurrentContext
  }
  
  open override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.view.backgroundColor = SystemColor.basicBlack.uiColor.withAlphaComponent(0.2)
    }
    animatePresentation()
  }
  
  open override func configureUI() {
    view.addSubview(containerView)
    
    // 설정한 contentView를 containerView에 추가합니다.
    containerView.addSubview(contentView)
    
    // contentView를 containerView의 하위뷰로 추가한 후, Auto Layout을 설정합니다.
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    // 초기에 containerView를 숨깁니다.
    containerView.snp.makeConstraints {
      $0.top.equalTo(view.snp.bottom)
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  private func animatePresentation() {

    containerView.snp.remakeConstraints {
      $0.bottom.leading.trailing.equalToSuperview()
      $0.height.equalTo(contentView.frame.height)
    }
    
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
  
  private func animateDismiss() {
    containerView.snp.remakeConstraints {
      $0.top.equalTo(view.snp.bottom)
      $0.leading.trailing.equalToSuperview()
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.view.layoutIfNeeded()
      self?.view.backgroundColor = .clear
    } completion: { [weak self] bool in
      self?.dismiss(animated: false)
    }

  }
  
  open override func bind() {
    super.bind()
    
    contentView.closeEventRelay
      .subscribe(with: self) { owner, _ in
        owner.animateDismiss()
      }
      .disposed(by: disposeBag)
    
    view.rx.tapGesture { gesture, recognizer in
      gesture.delegate = self
      recognizer.simultaneousRecognitionPolicy = .always
    }
    .when(.recognized)
    .subscribe(with: self) { owner, gesture in
      owner.animateDismiss()
    }
    .disposed(by: disposeBag)
  }
}

extension CustomBottomSheetController: UIGestureRecognizerDelegate {
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    guard touch.view?.isDescendant(of: self.containerView) == false else { return false }
    return true
  }
}
