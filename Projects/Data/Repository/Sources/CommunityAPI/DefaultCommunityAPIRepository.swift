//
//  DefaultCommunityAPIRepository.swift
//  DataRepositoryInterface
//
//  Created by 윤지호 on 4/17/24.
//

import Foundation
import RxSwift
import Moya

import DomainCommunityInterface
import DataNetworkInterface
import DataRepositoryInterface

public final class DefaultCommunityAPIRepository: CommunityAPIRepository {
  
  private let communityAPIService: any CommunityAPIService
  
  public init(communityAPIService: any CommunityAPIService) {
    self.communityAPIService = communityAPIService
  }
  
  public func writeFeed(title: String, content: String, images: [Data]? = nil) -> Observable<Feed> {
    let requestDTO = WriteFeedRequestDTO(title: title, content: content, images: images)
    
    return communityAPIService.request(endPoint: .writePost(requestDTO), responseDTO: WriteFeedResponseDTO.self)
      .asObservable()
      .map { $0.toDomain() }
  }
}
