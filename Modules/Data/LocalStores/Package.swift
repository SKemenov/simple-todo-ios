// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LocalStores",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "LocalStores",
            targets: ["LocalStores"]
        ),
    ],
    targets: [
        .target(
            name: "LocalStores",
            path: "Sources/LocalStores",
            swiftSettings: [.swiftLanguageMode(.v5)],
        ),
        .testTarget(
            name: "LocalStoresTests",
            dependencies: ["LocalStores"]
        ),
    ]
)
