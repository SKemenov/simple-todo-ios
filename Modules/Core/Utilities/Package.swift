// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Utilities",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Utilities",
            targets: ["Utilities"]
        ),
    ],
    dependencies: [
        .package(path: "../Logging"),
    ],
    targets: [
        .target(
            name: "Utilities",
            dependencies: [
                "Logging",
            ],
            path: "Sources/Utilities",
        ),
        .testTarget(
            name: "UtilitiesTests",
            dependencies: ["Utilities"]
        ),
    ]
)
