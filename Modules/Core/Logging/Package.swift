// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Logging",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Logging",
            targets: ["Logging"]
        ),
    ],
    targets: [
        .target(
            name: "Logging",
            path: "Sources/Logging",
        ),
        .testTarget(
            name: "LoggingTests",
            dependencies: ["Logging"]
        ),
    ]
)
