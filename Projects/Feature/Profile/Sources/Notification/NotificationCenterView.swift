//
//  NotificationCenterView.swift
//  FeatureProfileInterface
//
//  Created by HUNHIE LEE on 2.05.2024.
//

import UIKit
import Then
import SharedDesignSystem

public enum NotificationType {
  case marketing
  case chat
  case feed
  
  public var badgeImagePath: SharedDesignSystemImages {
    switch self {
    case .marketing:
      return Images.badgeDefault
    case .chat:
      return Images.badgeChat
    case .feed:
      return Images.badgeFeed
    }
  }
}

public struct Notificationitem: Hashable {
  public let id: UUID = UUID()
  public let type: NotificationType
  public let title: String
  public let createdDate: Date
  public let isRead: Bool
}

public final class NotificationItemCell: UITableViewCell {
  public static let identifier = "NotificationItemCell"
  
  private let badgeImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.layer.masksToBounds = true
  }
  
  private let titleLabel: UILabel = UILabel().then {
    $0.font = SystemFont.body02.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  
  private let dateLabel: UILabel = UILabel().then {
    $0.font = SystemFont.caption03.font
    $0.textColor = SystemColor.gray600.uiColor
  }
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    
    titleLabel.text = nil
    dateLabel.text = nil
    badgeImageView.image = nil
    backgroundColor = nil
  }
  
  public func configureCell(item: Notificationitem) {
    backgroundColor = item.isRead ? nil : SystemColor.primaryLight.uiColor
    titleLabel.text = item.title
    dateLabel.text = item.createdDate.formatRelativeDate()
    badgeImageView.image = UIImage(asset: item.type.badgeImagePath)
    configureUI()
  }
  
  private func configureUI() {
    addSubview(badgeImageView)
    badgeImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(40)
    }
    badgeImageView.makeCircle(with: 40)
    
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(badgeImageView.snp.trailing).offset(12)
      $0.top.equalTo(badgeImageView.snp.top).offset(1.5)
    }
    
    addSubview(dateLabel)
    dateLabel.snp.makeConstraints {
      $0.leading.equalTo(badgeImageView.snp.trailing).offset(12)
      $0.top.equalTo(titleLabel.snp.bottom).offset(4)
    }
  }
}

final class NotificationCenterView: BaseView {
  public lazy var tableView: UITableView = UITableView(frame: .zero, style: .plain).then {
    $0.rowHeight = 80
    $0.separatorStyle = .none
  }
  
  private var diffableDataSource: UITableViewDiffableDataSource<Int, Notificationitem>?
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureDataSource()
    tableView.register(NotificationItemCell.self, forCellReuseIdentifier: NotificationItemCell.identifier)
  }
  
  override func configureUI() {
    addSubview(tableView)
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func configureDataSource() {
    diffableDataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier -> UITableViewCell? in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationItemCell.identifier, for: indexPath) as? NotificationItemCell else { return nil }
      cell.configureCell(item: itemIdentifier)
      cell.selectionStyle = .none
      return cell
    })
  }
  
  public func applySnapShot(items: [Notificationitem], animatingDiffrences: Bool = false) {
    var snapShot = NSDiffableDataSourceSnapshot<Int, Notificationitem>()
    snapShot.appendSections([0])
    snapShot.appendItems(items, toSection: 0)
    diffableDataSource?.apply(snapShot, animatingDifferences: animatingDiffrences)
  }
}
