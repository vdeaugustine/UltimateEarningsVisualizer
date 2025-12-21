// swift-tools-version: 5.9
// Package.swift - SimulatorScreenshotter
// Created: 2025-08-18
// Purpose: Reusable Swift package and CLI tool for manual screenshot capture via iOS Simulator
// Usage: Use as executable CLI tool or integrate into build scripts for controlled screenshot automation

import PackageDescription

let package = Package(
    name: "SimulatorScreenshotter",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "SimulatorScreenshotter",
            targets: ["SimulatorScreenshotter"]
        ),
        .executable(
            name: "screenshot-cli",
            targets: ["ScreenshotCLI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "SimulatorScreenshotter",
            dependencies: []
        ),
        .executableTarget(
            name: "ScreenshotCLI",
            dependencies: [
                "SimulatorScreenshotter",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "SimulatorScreenshotterTests",
            dependencies: ["SimulatorScreenshotter"]
        ),
    ]
)