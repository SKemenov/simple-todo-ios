// swift-tools-version: 5.9
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
    dependencies: [
        .package(path: "../../Core/Logging"),
        .package(path: "../../Core/Utilities"),
        .package(path: "../../Domain/DomainInterface"),
        .package(path: "../DataInterface"),
    ],
    targets: [
        .target(
            name: "LocalStores",
            dependencies: [
                "Logging",
                "Utilities",
                "DomainInterface",
                "DataInterface",
            ],
            path: "Sources/LocalStores",
            resources: [
                .process("Resources/"),
            ],
        ),
        .testTarget(
            name: "LocalStoresTests",
            dependencies: ["LocalStores"]
        ),
    ]
)
