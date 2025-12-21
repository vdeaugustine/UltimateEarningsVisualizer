// SimulatorScreenshotter.swift - SimulatorScreenshotter
// Created: 2025-08-18  
// Purpose: Main class for iOS Simulator screenshot automation with manual navigation support
// Usage: Initialize with config and call captureScreenshots() to automate simulator-based screenshot capture

import Foundation

/// Main class for simulator-based screenshot automation
public class SimulatorScreenshotter {
    private let config: SimulatorConfig
    
    public init(config: SimulatorConfig) {
        self.config = config
    }
    
    /// Main entry point for screenshot capture
    public func captureScreenshots() throws {
        log("Starting simulator screenshot automation...")
        
        // Boot simulator if needed
        if config.autoBootSimulator {
            try bootSimulator()
        }
        
        // Launch app if needed
        if config.autoLaunchApp {
            try launchApp()
        }
        
        // Capture screenshots for each configured screen
        try captureConfiguredScreens()
        
        log("Screenshot automation complete! Check \(config.outputDirectory.path)")
    }
    
    // MARK: - Simulator Management
    
    private func bootSimulator() throws {
        log("Booting simulator: \(config.deviceName)")
        
        let bootResult = shell("xcrun simctl boot '\(config.deviceName)' || echo 'Simulator already booted'")
        if bootResult != 0 {
            throw ScreenshotError.simulatorBootFailed
        }
        
        // Wait for simulator to boot
        sleep(5)
        log("Simulator booted successfully")
    }
    
    private func launchApp() throws {
        log("Launching app: \(config.appBundleId)")
        
        let launchResult = shell("xcrun simctl launch '\(config.deviceName)' '\(config.appBundleId)'")
        if launchResult != 0 {
            throw ScreenshotError.appLaunchFailed
        }
        
        // Wait for app to launch
        sleep(UInt32(config.appLaunchDelay))
        log("App launched successfully")
    }
    
    // MARK: - Screenshot Capture
    
    private func captureConfiguredScreens() throws {
        for (index, screen) in config.screens.enumerated() {
            try captureScreen(screen, index: index + 1)
        }
    }
    
    private func captureScreen(_ screen: ScreenConfig, index: Int) throws {
        if config.manualNavigation {
            try captureScreenManually(screen, index: index)
        } else {
            try captureScreenAutomatically(screen, index: index)
        }
    }
    
    private func captureScreenManually(_ screen: ScreenConfig, index: Int) throws {
        print("\n--- Screen \(index): \(screen.name) ---")
        print("📱 \(screen.instructions)")
        print("⏳ Press Enter when ready to take screenshot...")
        
        let _ = readLine() // Wait for user input
        
        try takeScreenshot(for: screen, index: index)
    }
    
    private func captureScreenAutomatically(_ screen: ScreenConfig, index: Int) throws {
        log("Auto-capturing screen \(index): \(screen.name)")
        
        // Brief delay for any animations
        sleep(1)
        
        try takeScreenshot(for: screen, index: index)
    }
    
    private func takeScreenshot(for screen: ScreenConfig, index: Int) throws {
        let fileName = "\(String(format: "%02d", index))_\(config.filePrefix)_\(screen.filename).png"
        let outputPath = config.outputDirectory.appendingPathComponent(fileName)
        
        let command = "xcrun simctl io '\(config.deviceName)' screenshot '\(outputPath.path)'"
        let result = shell(command)
        
        if result == 0 {
            print("✅ Screenshot saved: \(fileName)")
        } else {
            print("❌ Failed to capture screenshot for \(screen.name)")
            throw ScreenshotError.screenshotCaptureFailed(screen.name)
        }
    }
    
    // MARK: - Helper Methods
    
    private func shell(_ command: String) -> Int32 {
        let task = Process()
        task.launchPath = "/bin/zsh"
        task.arguments = ["-c", command]
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
    
    private func log(_ message: String) {
        if config.verbose {
            print("[SimulatorScreenshotter] \(message)")
        }
    }
}

// MARK: - Error Types

public enum ScreenshotError: Error, LocalizedError {
    case simulatorBootFailed
    case appLaunchFailed
    case screenshotCaptureFailed(String)
    case invalidConfiguration
    
    public var errorDescription: String? {
        switch self {
        case .simulatorBootFailed:
            return "Failed to boot iOS Simulator"
        case .appLaunchFailed:
            return "Failed to launch app in simulator"
        case .screenshotCaptureFailed(let screenName):
            return "Failed to capture screenshot for \(screenName)"
        case .invalidConfiguration:
            return "Invalid configuration provided"
        }
    }
}

// MARK: - Convenience Methods

public extension SimulatorScreenshotter {
    /// Quick capture with minimal setup
    static func captureQuick(appBundleId: String, outputPath: String? = nil) throws {
        let config = SimulatorConfig.quick(appBundleId: appBundleId, outputPath: outputPath)
        let screenshotter = SimulatorScreenshotter(config: config)
        try screenshotter.captureScreenshots()
    }
    
    /// Minimal automated capture for CI/CD
    static func captureMinimal(appBundleId: String, outputPath: String? = nil) throws {
        let config = SimulatorConfig.minimal(appBundleId: appBundleId, outputPath: outputPath)
        let screenshotter = SimulatorScreenshotter(config: config)
        try screenshotter.captureScreenshots()
    }
    
    /// Comprehensive manual capture for documentation
    static func captureComprehensive(appBundleId: String, outputPath: String? = nil) throws {
        let config = SimulatorConfig.comprehensive(appBundleId: appBundleId, outputPath: outputPath)
        let screenshotter = SimulatorScreenshotter(config: config)
        try screenshotter.captureScreenshots()
    }
    
    /// Check if simulator and tools are available
    static func checkAvailability() -> Bool {
        let task = Process()
        task.launchPath = "/bin/zsh"
        task.arguments = ["-c", "which xcrun simctl"]
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus == 0
    }
    
    /// List available simulators
    static func listAvailableSimulators() throws -> [String] {
        let task = Process()
        let pipe = Pipe()
        
        task.launchPath = "/bin/zsh"
        task.arguments = ["-c", "xcrun simctl list devices available --json"]
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8) else {
            return []
        }
        
        // Parse JSON and extract device names (simplified)
        // In real implementation, would properly parse JSON
        let lines = output.components(separatedBy: .newlines)
        return lines.compactMap { line in
            if line.contains("\"name\"") && line.contains("iPhone") {
                return line.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            return nil
        }
    }
}