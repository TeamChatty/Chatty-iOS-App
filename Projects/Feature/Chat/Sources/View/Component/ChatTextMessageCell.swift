//
//  ChatTextMessageCell.swift
//  FeatureChat
//
//  Created by HUNHIE LEE on 2/13/24.
//

import UIKit
import SharedDesignSystem
import FeatureChatInterface

public final class ChatTextMessageCell: ChatMessageCell {
  private let bubbleView: UIView = UIView()
  
  private let textLabel: UILabel = UILabel().then {
    $0.lineBreakMode = .byCharWrapping
    $0.font = SystemFont.body03.font
    $0.numberOfLines = 0
  }
  
  public override func configureCell(with message: ChatMessageViewData, chatRoomType: ChatRoomType) {
    super.configureCell(with: message, chatRoomType: chatRoomType)
    setText(with: message)
    setTextLabelColor(with: message)
    setBubbleView(with: message)
    setupBubbleView()
    setupTextLabel()
  }
  
  private func setupTextLabel() {
    bubbleView.addSubview(textLabel)
    textLabel.snp.makeConstraints {
      $0.height.greaterThanOrEqualTo(20).priority(800)
      $0.verticalEdges.equalToSuperview().inset(8)
      $0.horizontalEdges.equalToSuperview().inset(12)
    }
  }
  
  private func setText(with message: ChatMessageViewData) {
    if case let .text(content) = message.content {
      textLabel.text = content
    }
  }
  
  private func setTextLabelColor(with message: ChatMessageViewData) {
    switch message.senderType {
    case .currentUser:
      textLabel.textColor = SystemColor.basicWhite.uiColor
    case .participant:
      textLabel.textColor = SystemColor.basicBlack.uiColor
    }
  }
  
  private func setBubbleView(with message: ChatMessageViewData) {
    switch message.senderType {
    case .currentUser:
      bubbleView.backgroundColor = SystemColor.primaryNormal.uiColor
      bubbleView.roundCorners(cornerRadius: 12, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner])
    case .participant:
      bubbleView.backgroundColor = chatRoomType == .unlimited ? SystemColor.gray100.uiColor : SystemColor.basicWhite.uiColor
      bubbleView.roundCorners(cornerRadius: 12, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner])
      
      if case .temporary = chatRoomType {
        bubbleView.layer.borderColor = SystemColor.gray200.uiColor.cgColor
        bubbleView.layer.borderWidth = 1
      }
    }
  }
  
  private func setupBubbleView() {
    messageView.addSubview(bubbleView)
    bubbleView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
