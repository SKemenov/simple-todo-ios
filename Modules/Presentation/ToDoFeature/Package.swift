// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ToDoFeature",
    defaultLocalization: "ru",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "ToDoFeature",
            targets: ["ToDoFeature"]
        ),
    ],
    dependencies: [
        .package(path: "../../Core/Logging"),
        .package(path: "../../Core/Utilities"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Domain/DomainInterface"),
        .package(path: "../../Domain/ToDoUseCases"),
    ],
    targets: [
        .target(
            name: "ToDoFeature",
            dependencies: [
                "Logging",
                "Utilities",
                "DesignSystem",
                "DomainInterface",
                "ToDoUseCases",
            ],
            resources: [
                .process("Resources/"),
            ],
        ),
        .testTarget(
            name: "ToDoFeatureTests",
            dependencies: ["ToDoFeature"]
        ),
    ]
)
