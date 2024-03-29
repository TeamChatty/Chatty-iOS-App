//
//  InterestAPIServiceImpl.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 3/7/24.
//

import Foundation
import DataNetworkInterface
import DataStorageInterface

import Moya
import RxSwift

public final class InterestAPIServiceImpl: InterestAPIService {
  public typealias Router = InterestAPIRouter
  public var provider: MoyaProvider<InterestAPIRouter>
  
  private let authAPIService: any AuthAPIService
  
  public init(authAPIService: any AuthAPIService, keychainService: KeychainServiceProtocol) {
    self.authAPIService = authAPIService
    self.provider = .init(plugins: [
      MoyaPlugin(keychainService: keychainService)
    ])
  }
}

extension InterestAPIServiceImpl {
  public func refreshToken() -> Single<Void> {
    return authAPIService.refreshToken()
  }
}
