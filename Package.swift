// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RepoToText",
    platforms: [
        // Adjust if you want a different minimum macOS version
        .macOS(.v10_15)
    ],
    products: [
        // Creates an executable named "repototext"
        .executable(name: "repototext", targets: ["RepoToText"])
    ],
    dependencies: [
        // Add any external dependencies here, e.g.,
        // .package(url: "https://github.com/Some/Package", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "RepoToText",
            dependencies: [
                // List target dependencies if needed
            ],
            path: "Sources/RepoToText" 
        )
    ]
)
