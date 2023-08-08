// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Trafaret",
    platforms: [
      .iOS(.v16),
      .macOS(.v10_15),
      .tvOS(.v13),
      .watchOS(.v6),
    ],
    products: [
        .library(name: "Trafaret", targets: ["Trafaret"]),
        .library(name: "TrafaretPackageExample", targets: ["TrafaretPackageExample"]),
    ],
    dependencies: [
        .package(url: "https://github.com/dmsl1805/swift-snapshot-testing", branch: "original-file-name"),
    ],
    targets: [
        .target(
            name: "TrafaretPackageExample",
            dependencies: [
                "Trafaret"
            ],
            exclude: [
                "__Trafarets__"
            ]
        ),
        .testTarget(
            name: "TrafaretPackageExampleTests",
            dependencies: [
                "TrafaretPackageExample",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ]
        ),
        .target(
            name: "Trafaret",
            dependencies: []
        ),
        .testTarget(
            name: "TrafaretTests",
            dependencies: [
                "Trafaret"
            ]
        ),
    ]
)
