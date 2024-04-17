//
//  Modules.swift
//  MyPlugin
//
//  Created by walkerhilla on 12/12/23.
//

import Foundation
import ProjectDescription

public enum ModulePath {
  case feature(Feature)
  case domain(Domain)
  case data(Data)
  case shared(Shared)
}

// MARK: AppModule

public extension ModulePath {
  enum App: String, CaseIterable {
    case IOS
    
    public static let name: String = "App"
  }
}


// MARK: FeatureModule
public extension ModulePath {
  enum Feature: String, CaseIterable {
    case Feed
    case Profile
    case Chat
    case Live
    case Onboarding
    
    public static let name: String = "Feature"
  }
}

// MARK: DomainModule

public extension ModulePath {
  enum Domain: String, CaseIterable {
    case Community
    case Live
    case Chat
    case Common
    case User
    case Auth
    
    public static let name: String = "Domain"
  }
}

// MARK: DataModule

public extension ModulePath {
  enum Data: String, CaseIterable {
    case Repository
    case Storage
    case Network
    
    public static let name: String = "Data"
  }
}

// MARK: SharedModule

public extension ModulePath {
  enum Shared: String, CaseIterable {
    case Firebase
    case Util
    case ThirdPartyLib
    case DesignSystem
    
    public static let name: String = "Shared"
  }
}
