//
//  UICollectionView+Extension.swift
//  SharedDesignSystem
//
//  Created by HUNHIE LEE on 2/13/24.
//

import UIKit

public extension UICollectionView {
  func scrollToBottomSkipping(animated: Bool) {
    let lastSectionIndex = max(0, numberOfSections - 1)
    let lastItemIndex = max(0, numberOfItems(inSection: lastSectionIndex) - 1)
    
    guard numberOfItems(inSection: lastSectionIndex) > 0 else { return }
    
    let indexPath = IndexPath(item: lastItemIndex, section: lastSectionIndex)
    guard let attributes = layoutAttributesForItem(at: indexPath) else { return }
    
    let lastItemBottom = attributes.frame.origin.y + attributes.frame.size.height
    let visibleBottom = contentOffset.y + bounds.size.height
    
    let distanceToBottom = lastItemBottom - visibleBottom
    let threshold: CGFloat = 100
    
    if distanceToBottom > threshold {
      let indexPath1 = IndexPath(item: max(0, lastItemIndex - 2), section: lastSectionIndex)
      scrollToItem(at: indexPath1, at: .bottom, animated: false)
    }
    
    scrollToItem(at: indexPath, at: .bottom, animated: animated)
  }
}
