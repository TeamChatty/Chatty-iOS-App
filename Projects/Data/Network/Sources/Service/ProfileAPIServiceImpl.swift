//
//  ProfileAPIServiceImpl.swift
//  DataNetwork
//
//  Created by HUNHIE LEE on 2/26/24.
//

import Foundation
import Moya
import DataStorageInterface
import DataNetworkInterface
import RxSwift

public final class ProfileAPIServiceImpl: ProfileAPIService {
  public typealias Router = ProfileAPIRouter
  public var provider: MoyaProvider<ProfileAPIRouter>
  
  private let authAPIService: any AuthAPIService
  
  public init(authAPIService: any AuthAPIService, keychainService: KeychainServiceProtocol) {
    self.authAPIService = authAPIService
    self.provider = .init(plugins: [
      MoyaPlugin(keychainService: keychainService)
    ])
  }
}

extension ProfileAPIServiceImpl {
  public func refreshToken() -> Single<Void> {
    return authAPIService.refreshToken()
  }
}
