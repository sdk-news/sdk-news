// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "sdk-diff-tool",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(name: "sdk-diff-tool", targets: ["sdk-diff-tool"]),
    ],
    targets: [
        .target(name: "sdk-diff-tool", dependencies: []),
    ]
)
