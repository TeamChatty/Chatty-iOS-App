//
//  Dependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by walkerhilla on 12/12/23.
//

import ProjectDescription
import ProjectDescriptionHelpers

let SPM = SwiftPackageManagerDependencies(
  [
    .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMajor(from: "5.6.0")),
    .remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .upToNextMajor(from: "6.6.0")),
    .remote(url: "https://github.com/ReactorKit/ReactorKit.git", requirement: .upToNextMajor(from: "3.2.0")),
    .remote(url: "https://github.com/Moya/Moya.git", requirement: .upToNextMajor(from: "15.0.3")),
    .remote(url: "https://github.com/devxoul/Then.git", requirement: .upToNextMajor(from: "3.0.0")),
    .remote(url: "https://github.com/RxSwiftCommunity/RxGesture.git", requirement: .upToNextMajor(from: "4.0.4")),
    .remote(url: "https://github.com/realm/realm-swift.git", requirement: .upToNextMajor(from: "10.46.0")),
    .remote(url: "https://github.com/guoyingtao/Mantis.git", requirement: .upToNextMajor(from: "2.19.0")),
    .remote(url: "https://github.com/kaishin/Gifu.git", requirement: .upToNextMajor(from: "3.4.0")),
    .remote(url: "https://github.com/yhkaplan/DoubleSlider", requirement: .upToNextMajor(from: "1.0.0")),
    .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "7.0.0")),
    .remote(url: "https://github.com/daltoniam/Starscream", requirement: .exact("4.0.4")),
    .remote(url: "https://github.com/Romixery/SwiftStomp.git", requirement: .exact("1.1.1"))
  ],
  productTypes: [
    "RxGesture": .framework,
    "Then": .framework,
    "ReactorKit": .framework,
    "Moya": .framework,
    "RxMoya": .framework,
    "ReactiveMoya": .framework,
    "CombineMoya": .framework,
    "Alamofire": .framework,
    "Mantis": .framework,
    "DoubleSlider": .framework
  ],
  baseSettings: .settings(
    configurations: [
      .debug(name: .debug),
      .release(name: .release)
    ]
  )
)

let dependencies = Dependencies(
    swiftPackageManager: SPM,
    platforms: [.iOS]
)
