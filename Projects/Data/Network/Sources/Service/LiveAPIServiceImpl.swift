//
//  LiveAPIService.swift
//  DataNetwork
//
//  Created by 윤지호 on 2/3/24.
//

import Foundation
import DataNetworkInterface
import DataStorageInterface

import Moya
import RxSwift

public final class LiveAPIServiceImpl: LiveAPIService {
  public typealias Router = LiveAPIRouter
  public var provider: MoyaProvider<LiveAPIRouter>
  
  private let authAPIService: any AuthAPIService
  
  public init(authAPIService: any AuthAPIService, keychainService: KeychainServiceProtocol) {
    self.authAPIService = authAPIService
    self.provider = .init(plugins: [
      MoyaPlugin(keychainService: keychainService)
    ])
  }
}

extension LiveAPIServiceImpl {
  public func refreshToken() -> Single<Void> {
    return authAPIService.refreshToken()
  }
}
