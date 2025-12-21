// swift-tools-version: 5.9
// Package.swift - UITestScreenshotter
// Created: 2025-08-18
// Purpose: Reusable Swift package for automated UI test screenshot capture across iOS projects
// Usage: Import into UITest targets to enable comprehensive app screenshot automation

import PackageDescription

let package = Package(
    name: "UITestScreenshotter",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "UITestScreenshotter",
            targets: ["UITestScreenshotter"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "UITestScreenshotter",
            dependencies: []
        ),
        .testTarget(
            name: "UITestScreenshotterTests",
            dependencies: ["UITestScreenshotter"]
        ),
    ]
)