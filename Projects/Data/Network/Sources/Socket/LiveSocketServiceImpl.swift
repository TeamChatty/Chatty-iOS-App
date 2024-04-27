//
//  LiveSocketService.swift
//  DataNetworkInterface
//
//  Created by 윤지호 on 3/4/24.
//

import Foundation
import DataNetworkInterface
import DataStorageInterface
import DomainLiveInterface

import SharedUtil

import Starscream
import RxSwift

public final class LiveSocketServiceImpl: LiveSocketService {
  
  private let keychainService: KeychainServiceProtocol
  private let authAPIService: any AuthAPIService
  
  private let disposeBag = DisposeBag()
  
  public init(keychainService: KeychainServiceProtocol, authAPIService: any AuthAPIService) {
    self.keychainService = keychainService
    self.authAPIService = authAPIService
  }
  
  private var socket: WebSocket?
  private var socketStateSubject: PublishSubject<Void>?
  private var resultSubject: PublishSubject<MatchSocketResult>?
  
  /// accessToken 만료 코드와 refresh 코드 둘다 401로 오기 때문에
  /// 한번만 refresh를 호출하고 무한루프를 방지하기 위해 bool값을 이용했습니다.
  private var refreshed: Bool = false
  
  public func openSocket() -> PublishSubject<Void> {
    let webSocketOpenedSubject = PublishSubject<Void>()
    self.socketStateSubject = webSocketOpenedSubject
    if setupWebSocket() == false {
      webSocketOpenedSubject.onError(LiveSocketError.setupError)
    }
    return webSocketOpenedSubject
  }
  
  public func connectSocket() -> PublishSubject<MatchSocketResult> {
    let resultSubject = PublishSubject<MatchSocketResult>()
    self.resultSubject = resultSubject
    return resultSubject
  }
  
  private func setupWebSocket() -> Bool {
    guard let url = URL(string: "wss://dev.api.chattylab.org/ws/match") else { return false }
    var request = URLRequest(url: url)

    guard let accessToken: String = keychainService.read(type: .accessToken()) else { return false }
    let authValue = "Bearer" + " " + accessToken
    request.addValue(authValue, forHTTPHeaderField: "Authorization")
    
    socket = WebSocket(request: request)
    socket?.delegate = self
    socket?.connect()
    return true
  }
  
  public func disconnectSocket() {
    socket?.disconnect()
    socket?.delegate = nil
    resultSubject = nil
  }
  
  public func sendRequest(reqeust: MatchSocketRequestDTO) {
    do {
      let req = try JSONSerialization.data(withJSONObject: reqeust.toDictionary())
      socket?.write(stringData: req, completion: {
        print("socket send success")
      })
    } catch {
      resultSubject?.onError(LiveSocketError.jsonEncodeError)
    }
  }
  
  deinit {
    socket?.disconnect()
    socket?.delegate = nil
    print("해제됨: LiveSocketService")
  }
}

extension LiveSocketServiceImpl: WebSocketDelegate {
  public func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocket) {
    switch event {
    case .connected(let dictionary):
      print("socket receive / connected")
      socketStateSubject?.onNext(())
    case .disconnected(let string, let uInt16):
      print("socket receive / disconnected")
      // socketStateSubject?.onError(LiveSocketError.disconnected)
    case .text(let string):
      guard let jsonDict: [String: Any] = string.toJSON() as? [String: Any] else { return }
      print(jsonDict)
      let matchResponseDTO = MatchSocketResponseDTO(jsonDict: jsonDict)
      resultSubject?.onNext(matchResponseDTO.toDomain())
    case .error(let error):
      getError(error)
    case .cancelled:
      print("websocket is canclled")
    default:
      break
    }
  }
}

extension LiveSocketServiceImpl {
  private func getError(_ error: Error?) {
    if let error = error as? Starscream.HTTPUpgradeError {
      switch error {
      case .notAnUpgrade(let int):
        switch int {
        case 401:
          handlrError(.refreshTokenExpiration401)
        default:
          handlrError(.error(error))
        }
      case .invalidData:
        handlrError(.error(error))
      }
    } else {
      handlrError(.error(error))
    }
  }
  
  private func handlrError(_ error: LiveSocketError) {
    switch error {
    case .refreshTokenExpiration401:
      _ = authAPIService.refreshToken()
        .subscribe(
          with: self,
          onSuccess: { owner, _ in
            _ = owner.setupWebSocket()
          },
          onFailure: { owner, error in
            owner.socketStateSubject?.onError(LiveSocketError.accessTokenExpiration)
          })
        .disposed(by: disposeBag)
    default:
      socketStateSubject?.onError(LiveSocketError.error(error))
    }
  }
}
