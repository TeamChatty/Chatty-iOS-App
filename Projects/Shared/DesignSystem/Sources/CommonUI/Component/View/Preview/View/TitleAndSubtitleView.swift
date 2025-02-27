//
//  TitleAndSubtitleView.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/3/24.
//

import UIKit
import SnapKit
import Then

public final class TitleContentView: BaseView {
  // MARK: - View Property
  private let titleLabel: UILabel = UILabel().then {
    $0.numberOfLines = 0
    $0.textAlignment = .left
  }
  private let contentLabel: UILabel = UILabel().then {
    $0.numberOfLines = 1
    $0.textAlignment = .right
  }
  
  // MARK: - Stored Property
  public var title: String? {
    didSet {
      self.titleLabel.text = title
    }
  }
  
  public var contentText: String? {
    didSet {
      self.contentLabel.text = contentText
    }
  }
  
  public var font: UIFont? {
    didSet {
      self.titleLabel.font = font
      self.contentLabel.font = font
    }
  }
  
  public var textColor: UIColor? {
    didSet {
      self.titleLabel.textColor = textColor
      self.contentLabel.textColor = textColor
    }
  }
  
  // MARK: - UIConfigurable
  public override func configureUI() {
    addSubview(titleLabel)
    addSubview(contentLabel)
    
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.height.equalTo(20)
      $0.horizontalEdges.equalToSuperview().inset(16)
    }
    
    contentLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.height.equalTo(20)
      $0.trailing.equalToSuperview().inset(16)
    }
  }
}
