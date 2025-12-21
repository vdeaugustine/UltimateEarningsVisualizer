// SimulatorConfig.swift - SimulatorScreenshotter
// Created: 2025-08-18
// Purpose: Configuration for iOS Simulator screenshot automation with device and app management
// Usage: Configure simulator device, app bundle ID, output settings, and automation behavior

import Foundation

/// Configuration for simulator-based screenshot automation
public struct SimulatorConfig {
    /// iOS Simulator device name
    public let deviceName: String
    
    /// App bundle identifier to launch
    public let appBundleId: String
    
    /// Output directory for screenshots
    public let outputDirectory: URL
    
    /// Screenshot file prefix
    public let filePrefix: String
    
    /// List of tabs/screens to capture
    public let screens: [ScreenConfig]
    
    /// Whether to boot simulator automatically
    public let autoBootSimulator: Bool
    
    /// Whether to launch app automatically
    public let autoLaunchApp: Bool
    
    /// Wait time after launching app (seconds)
    public let appLaunchDelay: Int
    
    /// Whether to require manual navigation (interactive mode)
    public let manualNavigation: Bool
    
    /// Whether to include verbose logging
    public let verbose: Bool
    
    public init(
        deviceName: String = "iPhone 16 Pro",
        appBundleId: String,
        outputDirectory: URL? = nil,
        filePrefix: String = "screenshot",
        screens: [ScreenConfig] = ScreenConfig.defaultScreens,
        autoBootSimulator: Bool = true,
        autoLaunchApp: Bool = true,
        appLaunchDelay: Int = 3,
        manualNavigation: Bool = true,
        verbose: Bool = true
    ) {
        self.deviceName = deviceName
        self.appBundleId = appBundleId
        self.outputDirectory = outputDirectory ?? URL(fileURLWithPath: NSHomeDirectory())
            .appendingPathComponent("Downloads")
        self.filePrefix = filePrefix
        self.screens = screens
        self.autoBootSimulator = autoBootSimulator
        self.autoLaunchApp = autoLaunchApp
        self.appLaunchDelay = appLaunchDelay
        self.manualNavigation = manualNavigation
        self.verbose = verbose
    }
}

/// Configuration for individual screen capture
public struct ScreenConfig {
    /// Display name for the screen
    public let name: String
    
    /// Instructions to show user for manual navigation
    public let instructions: String
    
    /// Output filename (without extension)
    public let filename: String
    
    public init(name: String, instructions: String? = nil, filename: String? = nil) {
        self.name = name
        self.instructions = instructions ?? "Navigate to the \(name) screen"
        self.filename = filename ?? name.lowercased().replacingOccurrences(of: " ", with: "_")
    }
    
    /// Default screens for most iOS apps
    public static let defaultScreens: [ScreenConfig] = [
        ScreenConfig(name: "Home", instructions: "Navigate to the Home tab"),
        ScreenConfig(name: "All Items", instructions: "Navigate to the All/List tab"),
        ScreenConfig(name: "Today", instructions: "Navigate to the Today/Current tab"),
        ScreenConfig(name: "Settings", instructions: "Navigate to the Settings tab")
    ]
    
    /// Minimal screens for quick testing
    public static let minimalScreens: [ScreenConfig] = [
        ScreenConfig(name: "Main", instructions: "Ensure app is on main screen")
    ]
    
    /// Comprehensive screens for thorough documentation
    public static let comprehensiveScreens: [ScreenConfig] = [
        ScreenConfig(name: "Home", instructions: "Navigate to Home tab"),
        ScreenConfig(name: "All Items", instructions: "Navigate to All/List tab"),
        ScreenConfig(name: "Add New", instructions: "Tap the + button or Add New item"),
        ScreenConfig(name: "Details", instructions: "Open any item details view"),
        ScreenConfig(name: "Today", instructions: "Navigate to Today/Current tab"),
        ScreenConfig(name: "Settings", instructions: "Navigate to Settings tab"),
        ScreenConfig(name: "Profile", instructions: "Open Profile or Account section"),
        ScreenConfig(name: "Help", instructions: "Navigate to Help or About section")
    ]
}

// MARK: - Convenience Initializers

public extension SimulatorConfig {
    /// Quick setup for most apps with automatic bundle ID detection
    static func quick(appBundleId: String, outputPath: String? = nil) -> SimulatorConfig {
        let outputDir = outputPath.map { URL(fileURLWithPath: $0) }
        return SimulatorConfig(
            appBundleId: appBundleId,
            outputDirectory: outputDir,
            screens: ScreenConfig.defaultScreens
        )
    }
    
    /// Minimal configuration for CI/CD
    static func minimal(appBundleId: String, outputPath: String? = nil) -> SimulatorConfig {
        let outputDir = outputPath.map { URL(fileURLWithPath: $0) }
        return SimulatorConfig(
            appBundleId: appBundleId,
            outputDirectory: outputDir,
            screens: ScreenConfig.minimalScreens,
            manualNavigation: false,
            verbose: false
        )
    }
    
    /// Comprehensive configuration for documentation
    static func comprehensive(appBundleId: String, outputPath: String? = nil) -> SimulatorConfig {
        let outputDir = outputPath.map { URL(fileURLWithPath: $0) }
        return SimulatorConfig(
            appBundleId: appBundleId,
            outputDirectory: outputDir,
            screens: ScreenConfig.comprehensiveScreens,
            appLaunchDelay: 5
        )
    }
    
    /// Fully automated configuration (no manual navigation)
    static func automated(appBundleId: String, outputPath: String? = nil) -> SimulatorConfig {
        let outputDir = outputPath.map { URL(fileURLWithPath: $0) }
        return SimulatorConfig(
            appBundleId: appBundleId,
            outputDirectory: outputDir,
            manualNavigation: false,
            appLaunchDelay: 2
        )
    }
}