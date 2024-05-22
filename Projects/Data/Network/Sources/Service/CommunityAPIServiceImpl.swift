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
import Alamofire

public final class CommunityAPIServiceImpl: CommunityAPIService {
  public typealias Router = CommunityAPIRouter
  public var provider: MoyaProvider<CommunityAPIRouter>
  
  private let authAPIService: any AuthAPIService
  private let keychainService: KeychainServiceProtocol
  
  public init(authAPIService: any AuthAPIService, keychainService: KeychainServiceProtocol) {
    self.authAPIService = authAPIService
    self.keychainService = keychainService
    self.provider = .init(plugins: [
      MoyaPlugin(keychainService: keychainService)
    ])
  }
  
//  public func requestUplodFeed<Model: Decodable>(endPoint: CommunityAPIRouter, responseDTO: Model.Type) {
//    DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
//      let urlPath = endPoint.baseURL
//      let fileName = "images"
//      
//      let bearer = self.keychainService.read(type: .accessToken())!
//      let requestHeaders: HTTPHeaders = [
//        "Authorization": "\(bearer)",
//        "Content-Type": "multipart/form-data"
//      ]
//      
//      switch endPoint {
//      case .writePost(let dto):
//        AF.upload(
//          multipartFormData: { multipartFormData in
//            for (index, image) in dto.images.enumerated() {
//              multipartFormData.append(image, withName: "image_\(index)", fileName: fileName, mimeType: "image/jpeg")
//            }
//            
//            let params: [String: String] = [
//              "title" : dto.title,
//              "content" : dto.content
//            ]
//            for (key, value) in params {
//              multipartFormData.append(value.data(using: .utf8)!, withName: key)
//            }
//            
//          },
//          to: urlPath,
//          method: .post,
//          headers: requestHeaders,
//          requestModifier: { requestModifier in
//            print(requestModifier)
//          }
//        )
//        .validate()
//        .response { response in
//          print(response)
//        }
//      default:
//        return
//      }
//      
//      
//    })
//    
//   
//  }

 
}

extension CommunityAPIServiceImpl {
  public func requestUplodFeedObs<Model: Decodable>(endPoint: CommunityAPIRouter, responseDTO: Model.Type) -> Single<Model> {
    return .create { emitter in
      self.requestUplodFeed(endPoint: endPoint, responseDTO: responseDTO) { result in
        switch result {
        case let .success(data):
          emitter(.success(data))
        case let .failure(err):
          emitter(.failure(err))
        }
      }
      return Disposables.create()
    }
  }
  
  private func requestUplodFeed<Model: Decodable>(endPoint: CommunityAPIRouter, responseDTO: Model.Type, onCompleted: @escaping ((Result<Model, Error>) -> Void)) {
    DispatchQueue.global().async {
      switch endPoint {
      case .writePost(let requestDTO):
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: endPoint.baseURL)
        request.httpMethod = "POST"
        request.setValue("bearer \(self.keychainService.read(type: .accessToken())!)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let httpBody = NSMutableData()

        httpBody.appendString(self.convertFormField(named: "content", value: requestDTO.content, using: boundary))
        
        for (index, image) in requestDTO.images.enumerated() {
          httpBody.append(self.convertFileData(fieldName: "images", fileName: "postImage_\(index).jpeg", mimeType: "image/jpeg", fileData: image, using: boundary))
        }
        
        httpBody.appendString("--\(boundary)--")
        
        request.httpBody = httpBody as Data
        
        URLSession.shared.dataTask(with: request) { data, response, error in
          if let error {
            print("error --> \(error)")
            onCompleted(.failure(error))
            return
          }
          
          guard let data = data else {
            let httpResponse = response as! HTTPURLResponse
            onCompleted(.failure(NSError(domain: "post data error -->",
                                         code: httpResponse.statusCode)))
            return
          }
          guard response != nil else { return }
          
          do {
            let decodedData = try JSONDecoder().decode(Model.self, from: data)
            onCompleted(.success(decodedData))
          } catch {
            onCompleted(.failure(NSError(domain: "post data json error -->",
                                         code: -1)))
          }
          
          
        }.resume()
      default:
        onCompleted(.failure(NSError(domain: "post url error2 -->",
                                     code: -2)))
        return
      }
    }
  }
  
  private func convertFormField(named name: String, value: String, using boundary: String) -> String {
    var fieldString = "--\(boundary)\r\n"
    fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
    fieldString += "\r\n"
    fieldString += "\(value)\r\n"

    return fieldString
  }
  
  private func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
    let data = NSMutableData()

    // ⭐️ 이미지가 여러 장일 경우 for 문을 이용해 data에 append 해줍니다.
    // (현재는 이미지 파일 한 개를 data에 추가하는 코드)
    data.appendString("--\(boundary)\r\n")
    data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
    data.appendString("Content-Type: \(mimeType)\r\n\r\n")
    data.append(fileData)
    data.appendString("\r\n")

    return data as Data
  }
}

extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}

extension CommunityAPIServiceImpl {
  public func refreshToken() -> Single<Void> {
    return authAPIService.refreshToken()
  }
}

