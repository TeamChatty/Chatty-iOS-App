//
//  ChatListView.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 2/22/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import SharedDesignSystem
import DomainChatInterface

public final class ChatListView: BaseView {
  public lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
    $0.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    $0.showsVerticalScrollIndicator = false
    $0.backgroundColor = SystemColor.basicWhite.uiColor
  }
  
  private let emptyView: UIView = UIView()
  private let emptyImage: UIImageView = UIImageView(image: UIImage(asset: Images.noChatHistory))
  private let emptyLabel: UILabel = UILabel().then {
    $0.text = "아직 채팅내역이 없어요"
    $0.font = SystemFont.body02.font
    $0.textColor = SystemColor.gray800.uiColor
  }
  private let emptyLetsChatButton: FillButton = FillButton(horizontalInset: 16).then {
    typealias Config = FillButton.Configuration
    let config = Config(backgroundColor: SystemColor.primaryNormal.uiColor, isEnabled: true, font: SystemFont.body01.font)
    $0.title = "대화하기"
    $0.setState(config, for: .enabled)
    $0.currentState = .enabled
    $0.layer.cornerRadius = 16
  }
  
  public override func configureUI() {
    addSubview(collectionView)
    
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  public func setEmptyView() {
    addSubview(emptyView)
    emptyView.addSubview(emptyImage)
    emptyView.addSubview(emptyLabel)
    emptyView.addSubview(emptyLetsChatButton)
    
    emptyView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    emptyImage.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.size.equalTo(124)
    }
    
    emptyLabel.snp.makeConstraints {
      $0.top.equalTo(emptyImage.snp.bottom).offset(23)
      $0.centerX.equalToSuperview()
    }
    
    emptyLetsChatButton.snp.makeConstraints {
      $0.top.equalTo(emptyLabel.snp.bottom).offset(23)
      $0.width.equalTo(81)
      $0.height.equalTo(33)
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
  
  public func removeEmptyView() {
    emptyView.removeFromSuperview()
  }
  
  private func createLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80))
      let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
      
      let section = NSCollectionLayoutSection(group: group)
      
      return section
    }
    return layout
  }
}
