//
//  TargetDependency.swift
//  MyPlugin
//
//  Created by walkerhilla on 12/12/23.
//

import Foundation
import ProjectDescription

// MARK: TargetDependency + App

public extension TargetDependency {
    static var app: Self {
        return .project(target: ModulePath.App.name, path: .app)
    }
    
    static func app(implements module: ModulePath.App) -> Self {
        return .target(name: ModulePath.App.name + module.rawValue)
    }
}

// MARK: TargetDependency + Feature

public extension TargetDependency {
    static var feature: Self {
        return .project(target: ModulePath.Feature.name, path: .feature)
    }
    
    static func feature(implements module: ModulePath.Feature) -> Self {
        return .project(target: ModulePath.Feature.name + module.rawValue, path: .feature(implementation: module))
    }
    
    static func feature(interface module: ModulePath.Feature) -> Self {
        return .project(target: ModulePath.Feature.name + module.rawValue + "Interface", path: .feature(implementation: module))
    }
    
    static func feature(tests module: ModulePath.Feature) -> Self {
        return .project(target: ModulePath.Feature.name + module.rawValue + "Tests", path: .feature(implementation: module))
    }
    
    static func feature(testing module: ModulePath.Feature) -> Self {
        return .project(target: ModulePath.Feature.name + module.rawValue + "Testing", path: .feature(implementation: module))
    }
    
}

// MARK: TargetDependency + Domain

public extension TargetDependency {
    static var domain: Self {
        return .project(target: ModulePath.Domain.name, path: .domain)
    }
    
    static func domain(implements module: ModulePath.Domain) -> Self {
        return .project(target: ModulePath.Domain.name + module.rawValue, path: .domain(implementation: module))
    }
    
    static func domain(interface module: ModulePath.Domain) -> Self {
        return .project(target: ModulePath.Domain.name + module.rawValue + "Interface", path: .domain(implementation: module))
    }
    
    static func domain(tests module: ModulePath.Domain) -> Self {
        return .project(target: ModulePath.Domain.name + module.rawValue + "Tests", path: .domain(implementation: module))
    }
    
    static func domain(testing module: ModulePath.Domain) -> Self {
        return .project(target: ModulePath.Domain.name + module.rawValue + "Testing", path: .domain(implementation: module))
    }
}

// MARK: TargetDependency + Data

public extension TargetDependency {
    static var data: Self {
        return .project(target: ModulePath.Data.name, path: .data)
    }
    
    static func data(implements module: ModulePath.Data) -> Self {
        return .project(target: ModulePath.Data.name + module.rawValue, path: .data(implementation: module))
    }
    
    static func data(interface module: ModulePath.Data) -> Self {
        return .project(target: ModulePath.Data.name + module.rawValue + "Interface", path: .data(implementation: module))
    }
    
    static func data(tests module: ModulePath.Data) -> Self {
        return .project(target: ModulePath.Data.name + module.rawValue + "Tests", path: .data(implementation: module))
    }
    
    static func data(testing module: ModulePath.Data) -> Self {
        return .project(target: ModulePath.Data.name + module.rawValue + "Testing", path: .data(implementation: module))
    }
}

// MARK: TargetDependency + Shared

public extension TargetDependency {
    static var shared: Self {
        return .project(target: ModulePath.Shared.name, path: .shared)
    }
    
    static func shared(implements module: ModulePath.Shared) -> Self {
        return .project(target: ModulePath.Shared.name + module.rawValue, path: .shared(implementation: module))
    }
    
    static func shared(interface module: ModulePath.Shared) -> Self {
        return .project(target: ModulePath.Shared.name + module.rawValue + "Interface", path: .shared(implementation: module))
    }
}
