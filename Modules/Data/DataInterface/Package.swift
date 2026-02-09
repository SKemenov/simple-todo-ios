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
    targets: [
        .target(
            name: "DataInterface",
            path: "Sources/DataInterface",
            swiftSettings: [.swiftLanguageMode(.v5)],
        ),
        .testTarget(
            name: "DataInterfaceTests",
            dependencies: ["DataInterface"]
        ),
    ]
)
