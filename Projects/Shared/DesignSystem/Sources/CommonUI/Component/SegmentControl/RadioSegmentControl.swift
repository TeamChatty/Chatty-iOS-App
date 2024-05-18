//
//  RadioSegmentControl.swift
//  SharedDesignSystem
//
//  Created by HUNHIE LEE on 1/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

public struct RadioSegmentItem: Equatable {
  public let id: Int
  public let title: String
  
  public init(id: Int, title: String) {
    self.id = id
    self.title = title
  }
}

public final class RadioSegmentControl<State: IntCaseIterable>: BaseControl, Touchable {
  
  public var touchEventRelay: PublishRelay<State> = .init()
  public typealias State = State
  
  public func selectSingleState(_ state: State) {
    // 선택한 상태를 제외한 나머지 상태를 unselected로 설정
    buttons.forEach {
      if $0.id.rawValue != state.rawValue {
        $0.currentState = .unSelected
      }
    }
  }
  
  private var buttons: [RadioButton] = [] {
    didSet {
      setupButtons(buttons)
    }
  }
  
  public let items: PublishRelay<[RadioSegmentItem]> = .init()
  
  private let stackView: UIStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .fill
    $0.spacing = 12
  }
  
  // MARK: - Initialize Method
  public init() {
    super.init(frame: .zero)
  }
  
  public override func configureUI() {
    addSubview(stackView)
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  public override func bind() {
    items
      .subscribe(with: self) { owner, items in
        owner.buttons = State.allCases.map {
          let view = RadioButton(title: items[$0.rawValue].title, id: $0)
          view.currentState = .unSelected
          return view
        }
      }
      .disposed(by: disposeBag)
  }
  
  private func setupButtons(_ buttons: [RadioButton]) {
    disposeBag = DisposeBag()
    buttons.enumerated().forEach { index, button in
      stackView.addArrangedSubview(button)
      button.snp.makeConstraints {
        $0.height.equalTo(46)
      }
      button.touchEventRelay
        .compactMap { _ in .init(rawValue: index) }
        .do { [weak self] state in
          self?.selectSingleState(state)
        }
        .bind(to: touchEventRelay)
        .disposed(by: disposeBag)
    }
  }
}
