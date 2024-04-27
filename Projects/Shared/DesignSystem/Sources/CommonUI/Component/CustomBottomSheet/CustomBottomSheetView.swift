//
//  CusomBottomSheetView.swift
//  SharedDesignSystem
//
//  Created by HUNHIE LEE on 16.04.2024.
//

import UIKit
import RxSwift
import RxCocoa

public protocol Closeable: NSObject {
  var closeEventRelay: PublishRelay<Void> { get }
}

open class CustomBottomSheetView: BaseView, Closeable {
  public let closeButton: CancelButton = CancelButton()
  public var closeEventRelay: PublishRelay<Void> = .init()
  public let disposeBag = DisposeBag()
  
  public override func bind() {
    super.bind()
    
    closeButton.touchEventRelay
      .map { Void() }
      .bind(to: closeEventRelay)
      .disposed(by: disposeBag)
  }
}
