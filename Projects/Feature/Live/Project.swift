import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
  name: ModulePath.Feature.name+ModulePath.Feature.Live.rawValue,
  targets: [    
        .feature(
            interface: .Live,
            factory: .init(
              dependencies: [
                .domain
              ]
            )
        ),
        .feature(
            implements: .Live,
            factory: .init(
                dependencies: [
                    .feature(interface: .Live),
                    .feature(interface: .Chat)
                ]
            )
        ),
    
        .feature(
            testing: .Live,
            factory: .init(
                dependencies: [
                    .feature(interface: .Live)
                ]
            )
        ),
        .feature(
            tests: .Live,
            factory: .init(
                dependencies: [
                    .feature(testing: .Live)
                ]
            )
        ),
    
        .feature(
            example: .Live,
            factory: .init(
                dependencies: [
                    .feature(interface: .Live)
                ]
            )
        )

    ]
)
