// swift-tools-version: 5.9
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
    dependencies: [
        .package(path: "../../Core/Logging"),
        .package(path: "../../Core/Utilities"),
        .package(path: "../../Domain/DomainInterface"),
        .package(path: "../DataInterface"),
        .package(path: "../LocalStores"),
        .package(path: "../Networking"),
    ],
    targets: [
        .target(
            name: "Repositories",
            dependencies: [
                "Logging",
                "Utilities",
                "DomainInterface",
                "DataInterface",
                "LocalStores",
                "Networking",
            ],
            path: "Sources/Repositories",
        ),
        .testTarget(
            name: "RepositoriesTests",
            dependencies: ["Repositories"]
        ),
    ]
)
