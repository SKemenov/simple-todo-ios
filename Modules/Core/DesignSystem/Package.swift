// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesignSystem",
    defaultLocalization: "ru",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]
        ),
    ],
    dependencies: [
        .package(path: "../Utilities"),
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: [
                "Utilities",
            ],
            path: "Sources/DesignSystem",
            resources: [
                .process("Resources/"),
            ],
            swiftSettings: [.swiftLanguageMode(.v5)],
        ),
        .testTarget(
            name: "DesignSystemTests",
            dependencies: ["DesignSystem"]
        ),
    ]
)
