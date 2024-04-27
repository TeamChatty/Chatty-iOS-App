//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by walkerhilla on 12/12/23.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let targets: [Target] = [
  .domain(
    factory: .init(
      dependencies: [
        .domain(implements: .Auth),
        .domain(implements: .User),
        .domain(implements: .Live),
        .domain(implements: .Chat),
        .domain(implements: .Community)
      ]
    )
  )
]

let project: Project = .makeModule(
  name: "Domain",
  targets: targets
)
