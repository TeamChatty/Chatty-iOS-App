//
//  ChatMessageCell.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 2/9/24.
//

import UIKit
import SharedDesignSystem
import Kingfisher
import FeatureChatInterface

public class ChatMessageCell: UICollectionViewCell {
  private lazy var profileImageView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.layer.masksToBounds = true
  }
  
  private lazy var nicknameLabel: UILabel = UILabel().then {
    $0.font = SystemFont.caption02.font
    $0.textColor = SystemColor.basicBlack.uiColor
  }
  
  public let timeLabel: UILabel = UILabel().then {
    $0.font = SystemFont.caption03.font
    $0.textColor = SystemColor.gray600.uiColor
  }
  
  public let messageView: UIView = UIView()
  
  private var message: ChatMessageViewData?
  private var profileImageURL: String?
  public var chatRoomType: ChatRoomType = .unlimited
  
  public func configureCell(with message: ChatMessageViewData, chatRoomType: ChatRoomType) {
    self.message = message
    self.chatRoomType = chatRoomType
    
    setupMessageView(with: message)
    if message.accessoryConfig.timeLabelVisible {
      timeLabel.text = message.sendTime?.toCustomString(format: .ahhmm)
    }
  }
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    
    contentView.removeAllSubviews()
    contentView.layoutIfNeeded()
    
    nicknameLabel.text = nil
    timeLabel.text = nil
    profileImageView.backgroundColor = nil
  }
  
  private func setupMessageView(with message: ChatMessageViewData) {
    contentView.addSubview(messageView)
    contentView.addSubview(timeLabel)
    
    switch message.senderType {
    case .currentUser:
      messageView.snp.makeConstraints {
        $0.trailing.equalToSuperview().inset(20)
        $0.top.bottom.equalToSuperview().inset(8)
        $0.width.lessThanOrEqualToSuperview().multipliedBy(0.65)
      }
      
      timeLabel.snp.makeConstraints {
        $0.trailing.equalTo(messageView.snp.leading).offset(-8)
        $0.bottom.equalTo(messageView)
      }
    case .participant(let profile):
      setupNicknameLabel(profile: profile)
      setupProfileImageView(profile: profile)
      
      messageView.snp.makeConstraints {
        $0.bottom.equalToSuperview().offset(-8)
        $0.width.lessThanOrEqualToSuperview().multipliedBy(0.55)
        
        switch chatRoomType {
        case .temporary:
          $0.leading.equalToSuperview().offset(20)
        case .unlimited:
          if message.accessoryConfig.nicknameAndProfileVisible {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(8)
          } else {
            $0.leading.equalToSuperview().offset(74)
            $0.top.equalToSuperview().offset(8)
          }
        }
        
        if message.accessoryConfig.nicknameAndProfileVisible {
          $0.top.equalTo(nicknameLabel.snp.bottom).offset(8)
        } else {
          $0.top.equalToSuperview().offset(8)
        }
      }
      
      timeLabel.snp.makeConstraints {
        $0.leading.equalTo(messageView.snp.trailing).offset(8)
        $0.bottom.equalTo(messageView)
      }
    }
  }
  
  private func setupProfileImageView(profile: ChatParticipantType.ParticipantProfile) {
    if case .unlimited = chatRoomType,
       let message,
       message.accessoryConfig.nicknameAndProfileVisible {
      contentView.addSubview(profileImageView)
      profileImageView.snp.makeConstraints {
        $0.leading.equalToSuperview().inset(20)
        $0.top.equalToSuperview().offset(8)
        $0.size.equalTo(44)
      }
      profileImageView.makeCircle(with: 44)
      if let url = profile.imageURL {
        profileImageView.kf.setImage(with: URL(string: url))
      } else {
        profileImageView.backgroundColor = SystemColor.gray400.uiColor
      }
    }
  }
  
  private func setupNicknameLabel(profile: ChatParticipantType.ParticipantProfile) {
    contentView.addSubview(nicknameLabel)
    nicknameLabel.snp.makeConstraints {
      if case .unlimited = chatRoomType {
        $0.leading.equalToSuperview().offset(74)
      } else {
        $0.leading.equalToSuperview().offset(20)
      }
      $0.top.equalToSuperview().offset(8)
    }
    
    if let message,
       message.accessoryConfig.nicknameAndProfileVisible {
      nicknameLabel.text = profile.name
    }
  }
}
