// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]
        ),
    ],
    targets: [
        .target(
            name: "DesignSystem",
            path: "Sources/DesignSystem",
            resources: [
            ],
            swiftSettings: [.swiftLanguageMode(.v5)],
        ),
        .testTarget(
            name: "DesignSystemTests",
            dependencies: ["DesignSystem"]
        ),
    ]
)
