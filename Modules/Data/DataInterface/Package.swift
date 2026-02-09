// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataInterface",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "DataInterface",
            targets: ["DataInterface"]
        ),
    ],
    dependencies: [
        .package(path: "../../Core/Logging"),
        .package(path: "../../Core/Utilities"),
        .package(path: "../../Domain/DomainInterface"),
    ],
    targets: [
        .target(
            name: "DataInterface",
            dependencies: [
                "Logging",
                "Utilities",
                "DomainInterface",
            ],
            path: "Sources/DataInterface",
            swiftSettings: [.swiftLanguageMode(.v5)],
        ),
        .testTarget(
            name: "DataInterfaceTests",
            dependencies: ["DataInterface"]
        ),
    ]
)
