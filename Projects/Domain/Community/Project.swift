import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
  name: ModulePath.Domain.name+ModulePath.Domain.Community.rawValue,
  targets: [    
    .domain(
      interface: .Community,
      factory: .init(
        dependencies: [
          .shared,
          .domain(implements: .Common)
        ]
      )
    ),
    .domain(
      implements: .Community,
      factory: .init(
        dependencies: [
          .domain(interface: .Community)
        ]
      )
    ),
    
      .domain(
        testing: .Community,
        factory: .init(
          dependencies: [
            .domain(interface: .Community)
          ]
        )
      ),
    .domain(
      tests: .Community,
      factory: .init(
        dependencies: [
          .domain(testing: .Community)
        ]
      )
    ),
    
  ]
)
