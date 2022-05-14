// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BwLogger",
    platforms: [
        .iOS(.v10),
        .macOS(.v10_10),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "BwLogger",
            targets: ["BwLogger", "BwTips"]
        ),
        .library(
            name: "BwTips",
            targets: ["BwTips"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "BwLogger",
            dependencies: ["BwTips"],
            cSettings: nil,
            cxxSettings: nil,
            swiftSettings: [.define("LOGGER_PRIVATE_EXTENSION_ENABLED")],
            linkerSettings: nil
        ),
        .testTarget(
            name: "BwLoggerTests",
            dependencies: ["BwLogger", "BwTips"],
            cSettings: nil,
            cxxSettings: nil,
            swiftSettings: [.define("LOGGER_PRIVATE_EXTENSION_ENABLED")],
            linkerSettings: nil
        ),
        .target(
            name: "BwTips",
            dependencies: [],
            cSettings: nil,
            cxxSettings: nil,
            swiftSettings: [.define("LOGGER_PRIVATE_EXTENSION_ENABLED")],
            linkerSettings: nil
        ),
    ]
)
