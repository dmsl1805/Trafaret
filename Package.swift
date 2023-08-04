// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Trafaret",
    platforms: [
      .iOS(.v13),
      .macOS(.v10_15),
      .tvOS(.v13),
      .watchOS(.v6),
    ],
    products: [
        .library(name: "Trafaret", targets: ["Trafaret"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "Trafaret",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
    ]
)
