// swift-tools-version:6.2

//
// This source file is part of the Stanford Spezi open source project
// 
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
// 
// SPDX-License-Identifier: MIT
//

import class Foundation.ProcessInfo
import PackageDescription


let package = Package(
    name: "SpeziVapor",
    platforms: [
        .macOS(.v26)
    ],
    products: [
        .library(name: "SpeziVapor", targets: ["SpeziVapor"]),
        .library(name: "SpeziVaporTesting", targets: ["SpeziVaporTesting"])
    ],
    dependencies: [
        .package(url: "https://github.com/StanfordSpezi/Spezi.git", from: "1.10.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0")
    ] + swiftLintPackage(),
    targets: [
        .target(
            name: "SpeziVapor",
            dependencies: [
                .product(name: "Spezi", package: "Spezi"),
                .product(name: "Vapor", package: "vapor")
            ],
            swiftSettings: [
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("InternalImportsByDefault")
            ],
            plugins: [] + swiftLintPlugin()
        ),
        .target(
            name: "SpeziVaporTesting",
            dependencies: [
                .target(name: "SpeziVapor"),
                .product(name: "Spezi", package: "Spezi"),
                .product(name: "VaporTesting", package: "vapor")
            ],
            swiftSettings: [
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("InternalImportsByDefault")
            ],
            plugins: [] + swiftLintPlugin()
        ),
        .testTarget(
            name: "SpeziVaporTests",
            dependencies: [
                .product(name: "Spezi", package: "Spezi"),
                .product(name: "VaporTesting", package: "vapor"),
                .target(name: "SpeziVapor"),
                .target(name: "SpeziVaporTesting")
            ],
            swiftSettings: [.enableUpcomingFeature("ExistentialAny")],
            plugins: [] + swiftLintPlugin()
        )
    ]
)


func swiftLintPlugin() -> [Target.PluginUsage] {
    // Fully quit Xcode and open again with `open --env SPEZI_DEVELOPMENT_SWIFTLINT /Applications/Xcode.app`
    if ProcessInfo.processInfo.environment["SPEZI_DEVELOPMENT_SWIFTLINT"] != nil {
        [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
    } else {
        []
    }
}

func swiftLintPackage() -> [PackageDescription.Package.Dependency] {
    if ProcessInfo.processInfo.environment["SPEZI_DEVELOPMENT_SWIFTLINT"] != nil {
        [.package(url: "https://github.com/realm/SwiftLint.git", from: "0.55.1")]
    } else {
        []
    }
}
