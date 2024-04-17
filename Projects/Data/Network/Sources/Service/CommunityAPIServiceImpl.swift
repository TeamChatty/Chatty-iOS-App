//
//  CommunityAPIServiceImpl.swift
//  DataNetwork
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation
import DataNetworkInterface
import DataStorageInterface

import Moya
import RxSwift

public final class CommunityAPIServiceImpl: CommunityAPIService {
  public typealias Router = CommunityAPIRouter
  public var provider: MoyaProvider<CommunityAPIRouter>
  
  private let authAPIService: any AuthAPIService
  
  public init(authAPIService: any AuthAPIService, keychainService: KeychainServiceProtocol) {
    self.authAPIService = authAPIService
    self.provider = .init(plugins: [
      MoyaPlugin(keychainService: keychainService)
    ])
  }
}

extension CommunityAPIServiceImpl {
  public func refreshToken() -> Single<Void> {
    return authAPIService.refreshToken()
  }
}

