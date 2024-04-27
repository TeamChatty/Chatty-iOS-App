//
//  DateHeaderSupplementaryView.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 12.04.2024.
//

import UIKit
import Then
import SnapKit
import SharedDesignSystem

public final class DateHeaderSupplementaryView: UICollectionReusableView {
  private let bubbleView: UIView = UIView().then {
    $0.backgroundColor = SystemColor.gray100.uiColor
    $0.layer.cornerRadius = 12
  }
  
  private let label: UILabel = UILabel().then {
    $0.textAlignment = .center
    $0.font = SystemFont.caption03.font
    $0.textColor = SystemColor.gray600.uiColor
  }
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    addSubview(bubbleView)
    bubbleView.addSubview(label)
    
    bubbleView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    label.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(12)
      $0.verticalEdges.equalToSuperview().inset(6)
    }
  }
  
  public func configure(with dateString: String?) {
    label.text = dateString
  }
}
