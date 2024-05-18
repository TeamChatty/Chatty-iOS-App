import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
  name: ModulePath.Feature.name+ModulePath.Feature.InAppPurchase.rawValue,
  targets: [    
        .feature(
            interface: .InAppPurchase,
            factory: .init(
              dependencies: [
                .domain
                ]
            )
        ),
        .feature(
            implements: .InAppPurchase,
            factory: .init(
                dependencies: [
                    .feature(interface: .InAppPurchase)
                ]
            )
        ),
    
        .feature(
            testing: .InAppPurchase,
            factory: .init(
                dependencies: [
                    .feature(interface: .InAppPurchase)
                ]
            )
        ),
        .feature(
            tests: .InAppPurchase,
            factory: .init(
                dependencies: [
                    .feature(testing: .InAppPurchase)
                ]
            )
        ),
    
        .feature(
            example: .InAppPurchase,
            factory: .init(
                dependencies: [
                    .feature(interface: .InAppPurchase)
                ]
            )
        )

    ]
)
