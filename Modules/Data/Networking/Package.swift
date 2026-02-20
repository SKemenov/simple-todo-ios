// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Networking",
            targets: ["Networking"]
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
            name: "Networking",
            dependencies: [
                "Logging",
                "Utilities",
                "DomainInterface",
                "DataInterface",
            ],
            path: "Sources/Networking",
        ),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"]
        ),
    ]
)
