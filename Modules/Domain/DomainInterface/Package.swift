// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DomainInterface",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "DomainInterface",
            targets: ["DomainInterface"]
        ),
    ],
    dependencies: [
        .package(path: "../../Core/Logging"),
        .package(path: "../../Core/Utilities"),
    ],
    targets: [
        .target(
            name: "DomainInterface",
            dependencies: [
                "Logging",
                "Utilities",
            ],
            path: "Sources/DomainInterface",
       ),
        .testTarget(
            name: "DomainInterfaceTests",
            dependencies: ["DomainInterface"]
        ),
    ]
)
