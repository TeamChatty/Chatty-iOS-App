//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by walkerhilla on 12/12/23.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
  name: ModulePath.Data.name+ModulePath.Data.Network.rawValue,
  targets: [
    .data(
      interface: .Network,
      factory: .init(
        dependencies: [
          .domain,
          .data(interface: .Storage)
        ]
      )
    ),
    .data(
      implements: .Network,
      factory: .init(
        dependencies: [
          .data(interface: .Network)
        ]
      )
    ),
    .data(
      testing: .Network,
      factory: .init(
        dependencies: [
          .data(interface: .Network)
        ]
      )
    ),
    .data(
      tests: .Network,
      factory: .init(
        dependencies: [
          .data(testing: .Network)
        ]
      )
    )
  ]
)
