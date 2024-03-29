//
//  LiveSocketError.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 3/6/24.
//

import Foundation

public enum LiveSocketError: Error {
  case connected
  case disconnected
  case jsonEncodeError
  case jsonDecodeError
  /// 리프레쉬 토큰 만료
  case refreshTokenExpiration401
  /// 토큰만료
  case accessTokenExpiration
  case setupError
  case error(Error?)
}
