//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by HUNHIE LEE on 12/12/23.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
  name: ModulePath.Shared.name+ModulePath.Shared.ThirdPartyLib.rawValue,
  targets: [
    .shared(
      implements: .ThirdPartyLib,
      factory: .init(
        dependencies: [
          .external(name: "ReactorKit"),
          .external(name: "RxSwift"),
          .external(name: "RxBlocking"),
          .external(name: "RxGesture"),
          .external(name: "RxMoya"),
          .external(name: "Moya"),
          .external(name: "SnapKit"),
          .external(name: "Then"),
          .external(name: "Realm"),
          .external(name: "Starscream"),
          .external(name: "Mantis"),
          .external(name: "Gifu"),
          .external(name: "SwiftStomp"),
          .external(name: "Kingfisher")
        ]
      )
    ),
  ]
)
