import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
  name: ModulePath.Feature.name+ModulePath.Feature.Feed.rawValue,
  targets: [
    .feature(
      interface: .Feed,
      factory: .init(
        dependencies: [
          .domain
        ]
      )
    ),
    .feature(
      implements: .Feed,
      factory: .init(
        dependencies: [
          .feature(interface: .Feed)
        ]
      )
    ),
    .feature(
      testing: .Feed,
      factory: .init(
        dependencies: [
          .feature(interface: .Feed)
        ]
      )
    ),
    .feature(
      tests: .Feed,
      factory: .init(
        dependencies: [
          .feature(testing: .Feed)
        ]
      )
    ),
    .feature(
      example: .Feed,
      factory: .init(
        dependencies: [
          .feature(interface: .Feed)
        ]
      )
    )
  ]
)
