// ScreenshotConfiguration.swift - UITestScreenshotter
// Created: 2025-08-18
// Purpose: Configuration struct for customizing screenshot automation behavior
// Usage: Configure output paths, tab names, features to explore, and timing settings

import Foundation

/// Configuration for screenshot automation behavior
public struct ScreenshotConfiguration {
    /// Output directory for screenshots (defaults to user's Downloads folder)
    public let outputDirectory: URL
    
    /// Custom tab names to look for (defaults to common patterns)
    public let tabNames: [String]
    
    /// Feature names to search for across the app
    public let featureNames: [String]
    
    /// Wait time between screenshots (seconds)
    public let screenshotDelay: UInt32
    
    /// Wait timeout for elements to appear (seconds)
    public let elementTimeout: Double
    
    /// Maximum number of navigation attempts per section
    public let maxNavigationAttempts: Int
    
    /// Whether to include detailed logging
    public let verbose: Bool
    
    /// App bundle identifier (for launching specific app)
    public let appBundleId: String?
    
    public init(
        outputDirectory: URL? = nil,
        tabNames: [String] = ["Home", "All", "Today", "Settings"],
        featureNames: [String] = [
            "Goals", "Expenses", "Shifts", "Allocations", "Time Blocks", 
            "Pay Periods", "Stats", "Tags", "Profile", "Notifications"
        ],
        screenshotDelay: UInt32 = 2,
        elementTimeout: Double = 5.0,
        maxNavigationAttempts: Int = 3,
        verbose: Bool = true,
        appBundleId: String? = nil
    ) {
        // Default to user's Downloads directory
        self.outputDirectory = outputDirectory ?? URL(fileURLWithPath: NSHomeDirectory())
            .appendingPathComponent("Downloads")
        
        self.tabNames = tabNames
        self.featureNames = featureNames
        self.screenshotDelay = screenshotDelay
        self.elementTimeout = elementTimeout
        self.maxNavigationAttempts = maxNavigationAttempts
        self.verbose = verbose
        self.appBundleId = appBundleId
    }
    
    /// Convenience initializer for minimal setup
    public static func minimal(outputPath: String? = nil) -> ScreenshotConfiguration {
        let outputDir = outputPath.map { URL(fileURLWithPath: $0) }
        return ScreenshotConfiguration(
            outputDirectory: outputDir,
            featureNames: [],
            maxNavigationAttempts: 1,
            verbose: false
        )
    }
    
    /// Convenience initializer for comprehensive testing
    public static func comprehensive(outputPath: String? = nil) -> ScreenshotConfiguration {
        let outputDir = outputPath.map { URL(fileURLWithPath: $0) }
        return ScreenshotConfiguration(
            outputDirectory: outputDir,
            featureNames: [
                "Goals", "Expenses", "Shifts", "Allocations", "Time Blocks", 
                "Pay Periods", "Stats", "Tags", "Profile", "Notifications",
                "Settings", "About", "Help", "Tutorial", "Onboarding",
                "Add", "Edit", "Create", "New", "Details", "List", "View"
            ],
            maxNavigationAttempts: 5,
            verbose: true
        )
    }
}