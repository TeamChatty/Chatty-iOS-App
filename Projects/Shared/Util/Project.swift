import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
  name: ModulePath.Shared.name+ModulePath.Shared.Util.rawValue,
  targets: [
    .shared(
      implements: .Util,
      factory: .init(
        dependencies: [
          .external(name: "SnapKit"),
          .external(name: "Then"),
        ]
      )
    ),
    
  ]
)
