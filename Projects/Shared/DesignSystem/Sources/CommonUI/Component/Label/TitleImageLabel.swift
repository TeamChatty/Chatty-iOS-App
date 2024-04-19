//
//  TitleImageLabel.swift
//  SharedDesignSystem
//
//  Created by 윤지호 on 3/24/24.
//

import UIKit
import SnapKit
import Then

public enum ImagePosition {
  case left
  case right
}

public final class TitleImageLabel: UIView {
  // MARK: - View Property
  private let imageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  private let titleLabel: UILabel = UILabel()
  
  // MARK: - Stored Property
  public var title: String? {
    didSet {
      self.titleLabel.text = title
    }
  }
  public var textColor: UIColor? {
    didSet {
      self.titleLabel.textColor = textColor
    }
  }
  public var font: UIFont? {
    didSet {
      self.titleLabel.font = font
    }
  }
  public var image: UIImage? {
    didSet {
      self.imageView.image = image
    }
  }
  public var imageViewTintColor: UIColor? {
    didSet {
      self.imageView.tintColor = imageViewTintColor
    }
  }
  
  // MARK: - Initialize Method

  public init(imageSize: Int, imagePosition: ImagePosition, space: Int) {
    super.init(frame: .zero)
    addSubview(imageView)
    addSubview(titleLabel)

    switch imagePosition {
    case .left:
      imageView.snp.makeConstraints {
        $0.centerY.equalToSuperview()
        $0.height.width.equalTo(imageSize)
        $0.leading.equalToSuperview()
      }
      titleLabel.snp.makeConstraints {
        $0.centerY.equalToSuperview()
        $0.height.equalToSuperview()
        $0.leading.equalTo(imageView.snp.trailing).offset(space)
        $0.trailing.equalToSuperview()
      }
    case .right:
      titleLabel.snp.makeConstraints {
        $0.centerY.equalToSuperview()
        $0.height.equalToSuperview()
        $0.leading.equalToSuperview()
      }
      
      imageView.snp.makeConstraints {
        $0.centerY.equalToSuperview()
        $0.height.width.equalTo(imageSize)
        $0.leading.equalTo(titleLabel.snp.trailing).offset(space)
        $0.trailing.equalToSuperview()
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
