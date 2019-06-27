// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Mustache",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Mustache",
            targets: ["Mustache"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/SwiftyJSON.git", from: "17.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Mustache",
            dependencies: ["SwiftyJSON"],
            path: "Sources"
        ),
        .testTarget(
            name: "MustacheTests",
            dependencies: ["Mustache"]
        ),
    ]
)
