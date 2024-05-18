//
//  CustomNavigationBarConfiguration.swift
//  SharedDesignSystem
//
//  Created by walkerhilla on 1/23/24.
//

import UIKit

public protocol CustomNavigationBarConfigurable: Equatable {
  var identifier: UUID { get }
  var titleView: CustomNavigationBarItem? { get }
  var titleAlignment: CustomNavigationBar.TitleAlignment { get }
  var rightButtons: [CustomNavigationBarButton] { get }
  var backgroundColor: UIColor { get }
  var backgroundOpacity: Float { get }
  var backgroundAlpha: CGFloat { get }
  var backButtonClosure: (() -> Void)? { get }
}

public struct CustomNavigationBarConfiguration: CustomNavigationBarConfigurable {
  public static func == (lhs: CustomNavigationBarConfiguration, rhs: CustomNavigationBarConfiguration) -> Bool {
    return lhs.identifier == rhs.identifier
  }
  
  public typealias Item = CustomNavigationBarItem
  public typealias Button = CustomNavigationBarButton
  public typealias Alignment = CustomNavigationBar.TitleAlignment
  
  public var identifier: UUID = UUID()
  public var titleView: Item?
  public var titleAlignment: Alignment
  public var rightButtons: [Button]
  public var backgroundColor: UIColor
  public var backgroundOpacity: Float
  public var backgroundAlpha: CGFloat
  public var backButtonClosure: (() -> Void)?
  
  public init(titleView: Item? = nil, titleAlignment: Alignment = .center, rightButtons: [Button] = [], backgroundColor: UIColor = .clear, backgroundOpacity: Float = 1, backgroundAlpha: CGFloat = 1, backButtonClosure: (() -> Void)? = nil) {
    guard rightButtons.count < 5 else {
      fatalError("CustomNavigationBarConfiguration Error: 버튼은 최대 4개까지 등록할 수 있습니다.")
    }
    self.titleView = titleView
    self.titleAlignment = titleAlignment
    self.rightButtons = rightButtons
    self.backgroundColor = backgroundColor
    self.backgroundOpacity = backgroundOpacity
    self.backgroundAlpha = backgroundAlpha
    self.backButtonClosure = backButtonClosure
  }
}
