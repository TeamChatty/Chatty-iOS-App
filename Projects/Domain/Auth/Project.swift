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
  name: ModulePath.Domain.name+ModulePath.Domain.Auth.rawValue,
  targets: [    
    .domain(
      interface: .Auth,
      factory: .init(
        dependencies: [
          .shared,
          .domain(implements: .Common)
        ]
      )
    ),
    .domain(
      implements: .Auth,
      factory: .init(
        dependencies: [
          .domain(interface: .Auth),
          .domain(interface: .User)
        ]
      )
    ),
    .domain(
      testing: .Auth,
      factory: .init(
        dependencies: [
          .domain(interface: .Auth)
        ]
      )
    ),
    .domain(
      tests: .Auth,
      factory: .init(
        dependencies: [
          .domain(testing: .Auth)
        ]
      )
    ),
  ]
)
