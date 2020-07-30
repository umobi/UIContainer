// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIContainer",
    platforms: [
        .iOS(.v13), .tvOS(.v13), .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "UIContainer",
            targets: ["UIContainer"])
    ],
    dependencies: [
        .package(url: "https://github.com/umobi/ConstraintBuilder", .upToNextMajor(from: "2.0.0"))
    ],
    targets: [
        .target(
            name: "UIContainer",
            dependencies: ["ConstraintBuilder"]),
        .testTarget(
            name: "UIContainerTests",
            dependencies: ["UIContainer"])
    ]
)
