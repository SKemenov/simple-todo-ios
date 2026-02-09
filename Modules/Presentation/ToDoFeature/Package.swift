// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ToDoFeature",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "ToDoFeature",
            targets: ["ToDoFeature"]
        ),
    ],
    targets: [
        .target(
            name: "ToDoFeature",
            path: "Sources/TodoFeature",
            swiftSettings: [.swiftLanguageMode(.v5)],
        ),
        .testTarget(
            name: "ToDoFeatureTests",
            dependencies: ["ToDoFeature"]
        ),
    ]
)
