//
//  ChatRoomListCell.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 2/23/24.
//

import UIKit
import Then
import SharedDesignSystem
import SharedUtil
import Kingfisher
import FeatureChatInterface

public final class ChatRoomListCell: UICollectionViewCell {
  private let containerView: UIView = UIView()
  private let profileImageView: UIImageView = UIImageView().then {
    $0.backgroundColor = SystemColor.gray300.uiColor
    $0.layer.masksToBounds = true
  }
  private let nameLabel: UILabel = UILabel().then {
    $0.font = SystemFont.body01.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  
  private let lastestMessageLabel: UILabel = UILabel().then {
    $0.numberOfLines = 2
    $0.font = SystemFont.body03.font
    $0.textColor = SystemColor.gray600.uiColor
  }
  
  private let lastestMessageTimeLabel: UILabel = UILabel().then {
    $0.font = SystemFont.caption03.font
    $0.textColor = SystemColor.gray500.uiColor
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implement")
  }
  
  public func configureCell(data: ChatRoomViewData) {
    setProfileImage(imageURL: data.recieverProfile.profileImageURL)
    setLastestMessage(message: data.lastMessage)
    setLastestMessageTime(message: data.lastMessage)
    setNameLabel(name: data.recieverProfile.name)
  }
  
  private func setProfileImage(imageURL: String?) {
    guard let imageURL,
          let url = URL(string: imageURL) else { return }
    profileImageView.kf.setImage(with: url)
  }
  
  private func setLastestMessage(message: ChatMessageViewData?) {
    guard let message else { return }
    switch message.content {
    case .text(let string):
      lastestMessageLabel.text = string
    }
  }
  
  private func setNameLabel(name: String) {
    nameLabel.text = name
  }
  
  private func setLastestMessageTime(message: ChatMessageViewData?) {
    guard let sendTime = message?.sendTime else { return }
    lastestMessageTimeLabel.text = toMessageTimeString(sendTime)
  }
  
  private func toMessageTimeString(_ time: Date?) -> String? {
    guard let time else { return nil }
    return time.toCustomString()
  }
               
  private func configureUI() {
    contentView.addSubview(containerView)
    containerView.addSubview(profileImageView)
    containerView.addSubview(nameLabel)
    containerView.addSubview(lastestMessageLabel)
    containerView.addSubview(lastestMessageTimeLabel)
    
    containerView.snp.makeConstraints {
      $0.verticalEdges.equalToSuperview().inset(16)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(48)
    }
    
    profileImageView.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.verticalEdges.equalToSuperview()
      $0.width.equalTo(48)
    }
    
    profileImageView.makeCircle(with: 48)
    
    lastestMessageTimeLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(1)
      $0.trailing.equalToSuperview()
    }
    
    nameLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(2)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
      $0.trailing.lessThanOrEqualTo(lastestMessageTimeLabel.snp.leading).offset(-15)
    }
    
    lastestMessageLabel.snp.makeConstraints {
      $0.top.equalTo(nameLabel.snp.bottom).offset(8)
      $0.bottom.equalToSuperview()
      $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
      $0.trailing.lessThanOrEqualTo(lastestMessageTimeLabel.snp.leading).offset(-15)
    }
  }
}
