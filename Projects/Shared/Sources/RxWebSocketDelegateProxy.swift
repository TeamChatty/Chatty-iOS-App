//
//  RxWebSocketDelegateProxy.swift
//  FeatureChatInterface
//
//  Created by HUNHIE LEE on 2/14/24.
//

//import Foundation
//import RxSwift
//import RxCocoa
//import Starscream
//
//public class RxWebSocketDelegateProxy: DelegateProxy<WebSocket, WebSocketDelegate>, DelegateProxyType, WebSocketDelegate {
//  var subject = PublishSubject<WebSocketEvent>()
//  
//  public func didReceive(event: Starscream.WebSocketEvent, client: WebSocketClient) {
//    subject.onNext(event)
//    print(event)
//  }
//  
//  public static func currentDelegate(for object: WebSocket) -> WebSocketDelegate? {
//    return object.delegate
//  }
//  
//  public static func setCurrentDelegate(_ delegate: WebSocketDelegate?, to object: WebSocket) {
//    object.delegate = delegate
//  }
//  
//  public static func registerKnownImplementations() {
//    self.register { inputViewController -> RxWebSocketDelegateProxy in
//      RxWebSocketDelegateProxy(parentObject: inputViewController, delegateProxy: self)
//    }
//  }
//}
//
//extension WebSocket: ReactiveCompatible { }
//
//public extension Reactive where Base: WebSocket {
//  var response: Observable<WebSocketEvent> {
//    return RxWebSocketDelegateProxy.proxy(for: base).subject
//  }
//  
//  var text: Observable<String> {
//    return self.response
//      .filter {
//        switch $0 {
//        case .text:
//          return true
//        default:
//          return false
//        }
//      }
//      .map {
//        switch $0 {
//        case .text(let message):
//          return message
//        default:
//          return String()
//        }
//      }
//  }
//  
//  var connected: Observable<Bool> {
//    return response
//      .filter {
//        switch $0 {
//        case .connected, .disconnected:
//          return true
//        default:
//          return false
//        }
//      }
//      .map {
//        switch $0 {
//        case .connected:
//          return true
//        default:
//          return false
//        }
//      }
//  }
//  
//  func write(data: Data) -> Observable<Void> {
//    return Observable.create { sub in
//      self.base.write(data: data) {
//        sub.onNext(())
//        sub.onCompleted()
//      }
//      
//      return Disposables.create()
//    }
//  }
//  
//  func write(ping: Data) -> Observable<Void> {
//    return Observable.create { sub in
//      self.base.write(ping: ping) {
//        sub.onNext(())
//        sub.onCompleted()
//      }
//      
//      return Disposables.create()
//    }
//  }
//  
//  func write(string: String) -> Observable<Void> {
//    return Observable.create { sub in
//      self.base.write(string: string) {
//        sub.onNext(())
//        sub.onCompleted()
//      }
//      
//      return Disposables.create()
//    }
//  }
//}
