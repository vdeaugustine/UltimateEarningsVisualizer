// UITestScreenshotter.swift - UITestScreenshotter  
// Created: 2025-08-18
// Purpose: Main screenshot automation class for comprehensive UI testing and app exploration
// Usage: Call `captureAllScreenshots()` from your UI test to automatically explore and screenshot your entire app

import XCTest
import Foundation

/// Main class for automated screenshot capture during UI testing
public class UITestScreenshotter {
    private let app: XCUIApplication
    private let config: ScreenshotConfiguration
    private var screenshotCounter = 1
    
    /// Initialize with app instance and optional configuration
    public init(app: XCUIApplication, config: ScreenshotConfiguration = ScreenshotConfiguration()) {
        self.app = app
        self.config = config
    }
    
    /// Main entry point - captures screenshots of entire app
    public func captureAllScreenshots() throws {
        log("Starting comprehensive screenshot capture...")
        
        // Ensure app is launched
        if !app.exists {
            app.launch()
        }
        
        // Wait for app to fully load
        let tabBar = app.tabBars.firstMatch
        if tabBar.exists {
            XCTAssertTrue(tabBar.waitForExistence(timeout: config.elementTimeout), "Tab bar should exist")
            try captureTabBasedApp()
        } else {
            try captureSingleViewApp()
        }
        
        log("Screenshot automation complete! Captured \(screenshotCounter - 1) screenshots.")
    }
    
    // MARK: - Tab-Based App Navigation
    
    private func captureTabBasedApp() throws {
        for tabName in config.tabNames {
            try captureTab(named: tabName)
        }
        
        // Additional exploration attempts
        try exploreAdditionalFeatures()
    }
    
    private func captureTab(named tabName: String) throws {
        log("Exploring \(tabName) tab...")
        
        let tab = app.tabBars.buttons[tabName]
        guard safeTap(tab) else {
            log("Could not find or tap \(tabName) tab")
            return
        }
        
        try takeScreenshot(name: "\(tabName.lowercased())_main")
        
        // Explore sub-views in this tab
        try exploreCurrentView(context: tabName.lowercased())
        
        // Look for specific features in this tab
        for feature in config.featureNames {
            try exploreFeature(feature, context: tabName.lowercased())
        }
    }
    
    // MARK: - Single View App Navigation
    
    private func captureSingleViewApp() throws {
        log("Capturing single-view app...")
        
        try takeScreenshot(name: "main_view")
        try exploreCurrentView(context: "main")
        
        for feature in config.featureNames {
            try exploreFeature(feature, context: "main")
        }
    }
    
    // MARK: - Feature Exploration
    
    private func exploreCurrentView(context: String) throws {
        // Try navigation bar buttons
        try exploreNavigationButtons(context: context)
        
        // Try floating action buttons
        try exploreFloatingButtons(context: context)
        
        // Try list cells
        try exploreCells(context: context)
        
        // Try general buttons
        try exploreButtons(context: context)
    }
    
    private func exploreFeature(_ feature: String, context: String) throws {
        let attempts = min(config.maxNavigationAttempts, 3)
        
        for attempt in 0..<attempts {
            // Try buttons containing feature name
            let buttons = app.buttons.containing(NSPredicate(format: "label CONTAINS[c] '\(feature)'"))
            if buttons.count > attempt, safeTap(buttons.element(boundBy: attempt)) {
                try takeScreenshot(name: "\(context)_\(feature.lowercased().replacingOccurrences(of: " ", with: "_"))")
                goBack()
                continue
            }
            
            // Try cells containing feature name
            let cells = app.cells.containing(NSPredicate(format: "label CONTAINS[c] '\(feature)'"))
            if cells.count > attempt, safeTap(cells.element(boundBy: attempt)) {
                try takeScreenshot(name: "\(context)_\(feature.lowercased().replacingOccurrences(of: " ", with: "_"))_list")
                goBack()
                continue
            }
            
            // Try static text that might be tappable
            let texts = app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] '\(feature)'"))
            if texts.count > attempt, safeTap(texts.element(boundBy: attempt)) {
                try takeScreenshot(name: "\(context)_\(feature.lowercased().replacingOccurrences(of: " ", with: "_"))_detail")
                goBack()
                continue
            }
            
            break // No more elements to try
        }
    }
    
    private func exploreAdditionalFeatures() throws {
        log("Exploring additional app features...")
        
        // Go back to first tab for additional exploration
        if let firstTab = config.tabNames.first {
            let tab = app.tabBars.buttons[firstTab]
            safeTap(tab)
        }
        
        try exploreFloatingButtons(context: "additional")
        try exploreNavigationButtons(context: "additional")
    }
    
    // MARK: - Specific Element Exploration
    
    private func exploreNavigationButtons(context: String) throws {
        let navBars = app.navigationBars
        for i in 0..<min(navBars.count, 2) {
            let navBar = navBars.element(boundBy: i)
            let navButtons = navBar.buttons
            for j in 0..<min(navButtons.count, 2) {
                let button = navButtons.element(boundBy: j)
                if button.exists && button.isHittable && !button.label.lowercased().contains("back") {
                    if safeTap(button) {
                        try takeScreenshot(name: "\(context)_nav_\(i)_\(j)")
                        goBack()
                    }
                }
            }
        }
    }
    
    private func exploreFloatingButtons(context: String) throws {
        let floatingButtons = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'plus' OR identifier CONTAINS[c] 'plus' OR identifier CONTAINS[c] 'add'"))
        for i in 0..<min(floatingButtons.count, 3) {
            if safeTap(floatingButtons.element(boundBy: i)) {
                try takeScreenshot(name: "\(context)_add_\(i + 1)")
                goBack()
            }
        }
    }
    
    private func exploreCells(context: String) throws {
        let cells = app.cells
        let maxCells = min(cells.count, 2)
        for i in 0..<maxCells {
            if safeTap(cells.element(boundBy: i)) {
                try takeScreenshot(name: "\(context)_item_\(i + 1)")
                goBack()
            }
        }
    }
    
    private func exploreButtons(context: String) throws {
        let buttons = app.buttons
        let maxButtons = min(buttons.count, 5)
        for i in 0..<maxButtons {
            let button = buttons.element(boundBy: i)
            if button.exists && button.isHittable && 
               !button.label.lowercased().contains("back") &&
               !button.label.isEmpty {
                if safeTap(button) {
                    try takeScreenshot(name: "\(context)_button_\(i + 1)")
                    goBack()
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /// Safely tap element if it exists and is hittable
    @discardableResult
    private func safeTap(_ element: XCUIElement, timeout: Double? = nil) -> Bool {
        let actualTimeout = timeout ?? config.elementTimeout
        if element.waitForExistence(timeout: actualTimeout) && element.isHittable {
            element.tap()
            sleep(1) // Brief pause after tap
            return true
        }
        return false
    }
    
    /// Navigate back using available back buttons
    private func goBack() {
        // Try navigation back button first
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        if backButton.exists && backButton.isHittable {
            backButton.tap()
            sleep(1)
            return
        }
        
        // Try dismiss/close buttons
        let dismissButtons = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'dismiss' OR label CONTAINS[c] 'close' OR label CONTAINS[c] 'done'"))
        if dismissButtons.count > 0 && safeTap(dismissButtons.firstMatch) {
            return
        }
        
        // Try escape/cancel buttons
        let cancelButtons = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'cancel'"))
        if cancelButtons.count > 0 && safeTap(cancelButtons.firstMatch) {
            return
        }
    }
    
    /// Take and save screenshot with proper naming
    private func takeScreenshot(name: String) throws {
        sleep(config.screenshotDelay) // Wait for content to load
        let screenshot = app.screenshot()
        let fileName = "\(String(format: "%02d", screenshotCounter))_\(name).png"
        let fileURL = config.outputDirectory.appendingPathComponent(fileName)
        try screenshot.pngRepresentation.write(to: fileURL)
        log("Screenshot saved: \(fileURL.path)")
        screenshotCounter += 1
    }
    
    /// Logging helper
    private func log(_ message: String) {
        if config.verbose {
            print("[UITestScreenshotter] \(message)")
        }
    }
}

// MARK: - Public Convenience Methods

public extension UITestScreenshotter {
    /// Quick setup for most common use case
    static func captureApp(_ app: XCUIApplication, outputPath: String? = nil) throws {
        let config = outputPath != nil ? 
            ScreenshotConfiguration(outputDirectory: URL(fileURLWithPath: outputPath!)) :
            ScreenshotConfiguration()
        
        let screenshotter = UITestScreenshotter(app: app, config: config)
        try screenshotter.captureAllScreenshots()
    }
    
    /// Minimal capture for CI/CD environments
    static func captureMinimal(_ app: XCUIApplication, outputPath: String? = nil) throws {
        let config = ScreenshotConfiguration.minimal(outputPath: outputPath)
        let screenshotter = UITestScreenshotter(app: app, config: config)
        try screenshotter.captureAllScreenshots()
    }
    
    /// Comprehensive capture for thorough testing
    static func captureComprehensive(_ app: XCUIApplication, outputPath: String? = nil) throws {
        let config = ScreenshotConfiguration.comprehensive(outputPath: outputPath)
        let screenshotter = UITestScreenshotter(app: app, config: config)
        try screenshotter.captureAllScreenshots()
    }
}