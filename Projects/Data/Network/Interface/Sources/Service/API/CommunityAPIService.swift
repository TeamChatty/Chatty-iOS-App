//
//  CommunityAPIService.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation
import Moya
import RxSwift

public protocol CommunityAPIService: APIServiceProtocol {
  var provider: MoyaProvider<CommunityAPIRouter> { get }
  func request<Model: Decodable>(endPoint: CommunityAPIRouter, responseDTO: Model.Type) -> Single<Model>
  func requestUplodFeedObs<Model: Decodable>(endPoint: CommunityAPIRouter, responseDTO: Model.Type) -> Single<Model>
}
