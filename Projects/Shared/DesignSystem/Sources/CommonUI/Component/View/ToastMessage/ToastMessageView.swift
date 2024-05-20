//
//  ToastMessageView.swift
//  SharedDesignSystem
//
//  Created by 윤지호 on 4/29/24.
//

import UIKit
import SnapKit
import Then

import RxSwift
import RxCocoa

public final class ToastMessageView: BaseView, Fadeable {
  // MARK: - View Property
  private let toastMessageButton: ToastMessageButton = ToastMessageButton().then {
    $0.backgroundColor = .black
    $0.layer.cornerRadius = 8
    $0.addShadow(location: .bottom)
    $0.alpha = 0
  }
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  // MARK: - Touchable Property
  
  // MARK: - UIConfigurable
  public override func configureUI() {
    addSubview(toastMessageButton)
    
  }
  // MARK: - UIBindable
  public override func bind() {
    toastMessageButton.snp.makeConstraints {
      $0.horizontalEdges.verticalEdges.equalToSuperview()
    }
  }
  
  private lazy var frame2: CGRect = self.frame
  
  public func showToastMessage(message: String) {
    toastMessageButton.showToastMessage(message: message)
    
    toastMessageButton.snp.remakeConstraints {
      $0.bottom.equalTo(self.snp.top).offset(-16)
      $0.height.equalTo(48)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    fadeIn([toastMessageButton], duration: .custom(0.8), alpha: .full)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
      self.fadeOut([self.toastMessageButton], duration: .custom(0.8), alpha: .transparent) { [weak self] in
        self?.toastMessageButton.snp.makeConstraints {
          $0.horizontalEdges.verticalEdges.equalToSuperview()
        }
      }
    })
  }
}
