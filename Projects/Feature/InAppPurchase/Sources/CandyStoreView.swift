//
//  CandyStoreView.swift
//  FeatureInAppPurchaseInterface
//
//  Created by HUNHIE LEE on 6.05.2024.
//

import UIKit
import SharedDesignSystem
import SharedUtil

public struct CandyListItem {
  public let quantity: Int
  public let status: DiscountStatus
  public let originalPrice: Int
  public var currentPrice: Int
  
  public enum DiscountStatus {
    case notOnSale
    case onSale(discountRate: Float)
  }
}

final class CandyListItemView: BaseView {
  private let candyImageView: UIImageView = UIImageView().then {
    $0.image = UIImage(asset: Images.candy)
    $0.contentMode = .scaleAspectFit
  }
  
  private let quantityLabel: UILabel = UILabel().then {
    $0.textColor = SystemColor.gray800.uiColor
    $0.font = SystemFont.title03.font
  }
  
  private let discountRateLabel: UILabel = UILabel().then {
    $0.textColor = SystemColor.primaryNormal.uiColor
    $0.font = Font.Pretendard(.Bold).of(size: 11)
  }
  
  private let currentPriceLabel: UILabel = UILabel().then {
    $0.textColor = SystemColor.gray600.uiColor
    $0.font = SystemFont.body01.font
  }
  
  private let originalPriceLabel: UILabel = UILabel().then {
    $0.font = Font.Pretendard(.Medium).of(size: 11)
    $0.textColor = SystemColor.gray500.uiColor
  }
  
  public let item: CandyListItem
  
  public init(item: CandyListItem) {
    self.item = item
    super.init(frame: .zero)
  }
}

public final class CandyStoreView: BaseView {
  private let contentView: UIView = UIView()
  
  private let ownedItemsView: UIView = UIView()
  private let ownedItemsLabel: UILabel = UILabel().then {
    $0.text = "보유 아이템"
    $0.textColor = SystemColor.gray800.uiColor
    $0.font = SystemFont.body01.font
  }
  private let candyItemImageView: UIImageView = UIImageView().then {
    $0.image = UIImage(asset: Images.candy)
    $0.contentMode = .scaleAspectFit
  }
  private let candyItemCountLabel: UILabel = UILabel().then {
    $0.font = SystemFont.body01.font
    $0.textColor = SystemColor.gray800.uiColor
  }
  private let ticketItemCountLabel: UILabel = UILabel().then {
    $0.font = SystemFont.body01.font
    $0.textColor = SystemColor.gray800.uiColor
  }
  
  public var candy: Int? {
    didSet {
      guard let candy else { return }
      
    }
  }
  public var ticket: Int? {
    didSet {
      guard let ticket else { return }
      
    }
  }
  
  private let salelistTitleLabel: UILabel = UILabel().then {
    $0.text = "캔디 구매"
    $0.textColor = SystemColor.basicBlack.uiColor
    $0.font = SystemFont.title03.font
  }
  private let salelistItem: UIStackView = UIStackView()
  
  private let policyView: UIView = UIView()
  
  public override func configureUI() {
    
  }
}
