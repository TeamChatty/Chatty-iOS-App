import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
  name: ModulePath.Feature.name+ModulePath.Feature.Chat.rawValue,
  targets: [
    .feature(
      interface: .Chat,
      factory: .init(
        dependencies: [
          .domain
        ]
      )
    ),
    .feature(
      implements: .Chat,
      factory: .init(
        dependencies: [
          .feature(interface: .Chat)
        ]
      )
    ),
    .feature(
      testing: .Chat,
      factory: .init(
        dependencies: [
          .feature(interface: .Chat)
        ]
      )
    ),
    .feature(
      tests: .Chat,
      factory: .init(
        dependencies: [
          .feature(testing: .Chat)
        ]
      )
    ),
    .feature(
      example: .Chat,
      factory: .init(
        dependencies: [
          .feature(implements: .Chat),
          .feature(interface: .Chat)
        ]
      )
    )
  ]
)
