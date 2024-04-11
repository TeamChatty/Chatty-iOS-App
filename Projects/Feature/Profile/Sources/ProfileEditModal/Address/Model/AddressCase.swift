//
//  AddressCase.swift
//  FeatureProfile
//
//  Created by 윤지호 on 4/4/24.
//

import Foundation
import SharedDesignSystem

enum AddressCase: Int, IntCaseIterable {
  case seoul
  case gyeonggiSouthern
  case gyeonggiNorthern
  case incheon
  case daejeon
  case chungcheongNorthern
  case chungcheongSouthern
  case gangwon
  case Busan
  case gyeongsangNorthern
  case gyeongsangSouthern
  case daegu
  case ulsan
  case gwangju
  case JeollaNorthern
  case JeollaSouthern
  case jeju
  
  
  static func getAddressCase(name: String) -> AddressCase {
    switch name {
    case "서울":
      return .seoul
    case "경기 남부":
      return .gyeonggiSouthern
    case "경기 북부":
      return .gyeonggiNorthern
    case "인천":
      return .incheon
    case "대전":
      return .daejeon
    case "충북":
      return .chungcheongNorthern
    case "충남":
      return .chungcheongSouthern
    case "강원":
      return .gangwon
    case "부산":
      return .Busan
    case "경북":
      return .gyeonggiNorthern
    case "경남":
      return .gyeonggiSouthern
    case "대구":
      return .daegu
    case "울산":
      return .ulsan
    case "광주":
      return .gwangju
    case "전북":
      return .JeollaNorthern
    case "전남":
      return .JeollaSouthern
    case "제주":
      return .jeju
    default:
      return .seoul
    }
  }
    
  var stringKR: String {
    switch self {
    case .seoul:
      return "서울"
    case .gyeonggiSouthern:
      return "경기 남부"
    case .gyeonggiNorthern:
      return "경기 북부"
    case .incheon:
      return "인천"
    case .daejeon:
      return "대전"
    case .chungcheongNorthern:
      return "충북"
    case .chungcheongSouthern:
      return "충남"
    case .gangwon:
      return "강원"
    case .Busan:
      return "부산"
    case .gyeongsangNorthern:
      return "경북"
    case .gyeongsangSouthern:
      return "경남"
    case .daegu:
      return "대구"
    case .ulsan:
      return "울산"
    case .gwangju:
      return "광주"
    case .JeollaNorthern:
      return "전북"
    case .JeollaSouthern:
      return "전남"
    case .jeju:
      return "제주"
    }
  }
}
