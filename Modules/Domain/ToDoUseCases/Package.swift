// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ToDoUseCases",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "ToDoUseCases",
//            type: .dynamic,
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
        ),
        .testTarget(
            name: "ToDoUseCasesTests",
            dependencies: ["ToDoUseCases"]
        ),
    ]
)
