//
//  HandleResponse.swift
//  DataNetwork
//
//  Created by 윤지호 on 1/28/24.
//

import Foundation
import RxSwift
import Moya
import DataNetworkInterface
import Starscream

/// PrimitiveSequence에 extension으로 API Reqeust를 정의한 코드입니다.
/// https://gist.github.com/hsleedevelop/edf8fa03ca5c3a1ec2e2878d361ffd7b 을 참고했습니다.
extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
  func handleResponse<Model: Decodable>(responseDTO: Model.Type) -> Single<Model> {
    return flatMap { response in
      /// 토큰 재발급 받았을 때 토큰 변경함
      do {
        let response = try JSONDecoder().decode(responseDTO.self, from: response.data)
        print("네트워크 통신 정상")
        return Single.just(response)
      } catch {
        print("네트워크 통신 에러 \(error)")
        do {
          print("네트워크 상태 코드\(response.statusCode)")
          let errorResponse = try JSONDecoder().decode(ErrorResponseDTO.self, from: response.data)
          let mappedError = errorResponse.toMappedError()
          return Single.error(mappedError)
        } catch {
          print("서버 에러 \(error)")
          return Single.error(error)
        }
      }
    }
  }
}

