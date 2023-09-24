// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SwiftTesting",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "SwiftTesting",
            targets: ["SwiftTesting"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-testing.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "SwiftTesting",
            dependencies: []
        ),
        .testTarget(
            name: "SwiftTestingTests",
            dependencies: [
                "SwiftTesting",
                .product(name: "Testing", package: "swift-testing"),
            ]
        )
    ]
)
