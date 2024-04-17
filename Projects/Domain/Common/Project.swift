import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
  name: ModulePath.Domain.name+ModulePath.Domain.Common.rawValue,
  targets: [
    .domain(
      implements: .Common,
      factory: .init(
        dependencies: [
          .shared
        ]
      )
    ),
  ]
)
