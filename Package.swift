// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "YMatterType",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14),
        .tvOS(.v14)
    ],
    products: [
        .library(
            name: "YMatterType",
            targets: ["YMatterType"]
        )
    ],
    targets: [
        .target(
            name: "YMatterType",
            dependencies: []
        ),
        .testTarget(
            name: "YMatterTypeTests",
            dependencies: ["YMatterType"],
            resources: [.copy("Assets")]
        )
    ]
)
