// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Repositories",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Repositories",
            targets: ["Repositories"]
        ),
    ],
    targets: [
        .target(
            name: "Repositories",
            path: "Sources/Repositories",
            swiftSettings: [.swiftLanguageMode(.v5)],
        ),
        .testTarget(
            name: "RepositoriesTests",
            dependencies: ["Repositories"]
        ),
    ]
)
