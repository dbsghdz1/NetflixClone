import ProjectDescription

let project = Project(
    name: "NetflixClone",
    settings: .settings(
      configurations: [
        .debug(name: .debug),
        .debug(name: "QA"),
        .release(name: .release)
      ]
    ), targets: [
      .target(
        name: "NetflixClone",
        destinations: .iOS,
        product: .app,
        bundleId: "io.tuist.NetflixClone",
        infoPlist: .extendingDefault(
          with: [
            "UILaunchScreen": [
              "UIColorName": "",
              "UIImageName": "",
            ],
          ]
        ),
        sources: ["NetflixClone/Sources/**"],
        resources: ["NetflixClone/Resources/**"],
        dependencies: [
          .external(name: "ComposableArchitecture"),
          .external(name: "Moya")
        ]
      ),
      .target(
        name: "NetflixCloneTests",
        destinations: .iOS,
        product: .unitTests,
        bundleId: "io.tuist.NetflixCloneTests",
        infoPlist: .default,
        sources: ["NetflixClone/Tests/**"],
        resources: [],
        dependencies: [.target(name: "NetflixClone")]
      ),
    ]
)
