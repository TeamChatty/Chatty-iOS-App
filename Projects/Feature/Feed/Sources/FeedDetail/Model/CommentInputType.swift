//
//  CommentType.swift
//  FeatureFeedInterface
//
//  Created by 윤지호 on 5/3/24.
//

import Foundation

public enum CommentInputType: Equatable {
  case comment
  case reply(commentId: Int)
  case cancel
}
