// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ToDoUseCases",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "ToDoUseCases",
            targets: ["ToDoUseCases"]
        ),
    ],
    dependencies: [
        .package(path: "../../Core/Logging"),
        .package(path: "../../Core/Utilities"),
        .package(path: "../DomainInterface"),
    ],
    targets: [
        .target(
            name: "ToDoUseCases",
            dependencies: [
                "Logging",
                "Utilities",
                "DomainInterface",
            ],
            path: "Sources/ToDoUseCases",
            swiftSettings: [.swiftLanguageMode(.v5)],
        ),
        .testTarget(
            name: "ToDoUseCasesTests",
            dependencies: ["ToDoUseCases"]
        ),
    ]
)
