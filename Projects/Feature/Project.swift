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
  .feature(
    factory: .init(
      dependencies: [
        .feature(implements: .Onboarding),
        .feature(implements: .Live),
        .feature(implements: .Chat),
        .feature(implements: .Profile),
        .feature(implements: .Feed),
        .feature(implements: .InAppPurchase)
      ]
    )
  )
]

let project: Project = .makeModule(
  name: "Feature",
  targets: targets
)
