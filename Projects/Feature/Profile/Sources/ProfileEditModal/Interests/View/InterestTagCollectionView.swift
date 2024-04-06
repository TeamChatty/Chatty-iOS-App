//
//  InterestTagsView.swift
//  FeatureOnboardingInterface
//
//  Created by 윤지호 on 1/24/24.
//

import UIKit
import RxSwift
import RxCocoa
import SharedDesignSystem
import Then
import SnapKit
import DomainUserInterface

final class InterestTagCollectionView: BaseView, Touchable {
  
  private var tagsCell: [InterestTagCollectionViewCell] = []
  private var tags: [Interest] = [] {
    didSet {
      configeCell()
    }
  }
  
  // MARK: View
  private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  // MARK: - Rx Property
  private let disposeBag = DisposeBag()
  
  // MARK: - Touchable Property
  public var touchEventRelay: PublishRelay<Interest> = .init()
  
  // MARK: - UIConfigurable
  override func configureUI() {
    setupCollectionView()
  }
}

extension InterestTagCollectionView {
  public func updateCollectionView(_ tags: [Interest]) {
    self.tags = tags
  }
  
  public func updateCell(_ selectedTags: [Interest]) {
    let tagIndexs = selectedTags.map { tag in
      let index = self.tags.firstIndex(where: { $0 == tag }) ?? 0
      return index
    }
    
    for index in tagIndexs {
      if let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? InterestTagCollectionViewCell {
        cell.updateCellState()
      }
    }
  }
}

extension InterestTagCollectionView {
  private func setupCollectionView() {
    addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.trailing.leading.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
    
    collectionView.dataSource = self
    collectionView.register(InterestTagCollectionViewCell.self, forCellWithReuseIdentifier: InterestTagCollectionViewCell.cellId)
    
    collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    configeCell()
  }
  
  private func configeCell() {
    self.tagsCell = tags.enumerated().map { index, item -> InterestTagCollectionViewCell in
      guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: InterestTagCollectionViewCell.cellId, for: IndexPath(row: index, section: 0)) as? InterestTagCollectionViewCell else {
        return UICollectionViewCell() as! InterestTagCollectionViewCell
      }
      cell.setData(tag: item)
      
      cell.touchEventRelay
        .map { _ in item }
        .bind(to: touchEventRelay)
        .disposed(by: disposeBag)
      
      return cell
    }
    
    self.collectionView.reloadData()
    self.collectionView.setCollectionViewLayout(setFlowLayout(), animated: true)
  }
}

extension InterestTagCollectionView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.tags.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return self.tagsCell[indexPath.item]
  }
}

extension InterestTagCollectionView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cell = tagsCell[indexPath.item]
    return cell.intrinsicContentSize
  }
  
  func setFlowLayout() -> LeftAlignedCollectionViewFlowLayout {
    let flowLayout = LeftAlignedCollectionViewFlowLayout()
    flowLayout.minimumLineSpacing = 12
    flowLayout.minimumInteritemSpacing = 8
    return flowLayout
  }
}

final class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
      let attributes = super.layoutAttributesForElements(in: rect)

      var leftMargin = sectionInset.left
      var maxY: CGFloat = -1.0
      attributes?.forEach { layoutAttribute in
          if layoutAttribute.frame.origin.y >= maxY {
              leftMargin = sectionInset.left
          }

          layoutAttribute.frame.origin.x = leftMargin

          leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
          maxY = max(layoutAttribute.frame.maxY , maxY)
      }

      return attributes
  }
}
