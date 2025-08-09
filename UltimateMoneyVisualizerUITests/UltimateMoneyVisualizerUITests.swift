//
//  UltimateMoneyVisualizerUITests.swift
//  UltimateMoneyVisualizerUITests
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import XCTest

final class UltimateMoneyVisualizerUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it's important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testScreenshotAllTabs() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Wait for app to fully load
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.waitForExistence(timeout: 10), "Tab bar should exist")
        
        // Use the host machine's Downloads directory instead of simulator's sandboxed directory
        let downloadsPath = URL(fileURLWithPath: "/Users/vincentdeaugustine/Downloads")
        
        var screenshotCounter = 1
        
        // Helper function to take and save screenshot
        func takeScreenshot(name: String) throws {
            sleep(2) // Wait for content to load
            let screenshot = app.screenshot()
            let fileName = "\(String(format: "%02d", screenshotCounter))_\(name).png"
            let fileURL = downloadsPath.appendingPathComponent(fileName)
            try screenshot.pngRepresentation.write(to: fileURL)
            print("Screenshot saved: \(fileURL.path)")
            screenshotCounter += 1
        }
        
        // Helper function to safely tap element if it exists
        func safeTap(_ element: XCUIElement, timeout: Double = 3.0) -> Bool {
            if element.waitForExistence(timeout: timeout) {
                element.tap()
                return true
            }
            return false
        }
        
        // Helper function to go back (tap back button or use navigation)
        func goBack() {
            let backButton = app.navigationBars.buttons.element(boundBy: 0)
            if backButton.exists && backButton.isHittable {
                backButton.tap()
                sleep(1)
            }
        }
        
        // MARK: - Main Tabs
        
        // 1. Home Tab
        let homeTab = app.tabBars.buttons["Home"]
        if safeTap(homeTab) {
            try takeScreenshot(name: "home_main")
            
            // Try to navigate to sub-views in Home tab
            if safeTap(app.buttons.matching(identifier: "Stats").firstMatch) {
                try takeScreenshot(name: "home_stats")
                goBack()
            }
            
            // Look for wage or earnings related buttons
            if safeTap(app.buttons.containing(NSPredicate(format: "label CONTAINS 'Wage'")).firstMatch) {
                try takeScreenshot(name: "home_wage")
                goBack()
            }
        }
        
        // 2. All Items Tab
        let allTab = app.tabBars.buttons["All"]
        if safeTap(allTab) {
            try takeScreenshot(name: "all_items_main")
            
            // Try to tap on different list items
            let cells = app.cells
            if cells.count > 0 {
                // Take screenshot of first item detail if available
                if safeTap(cells.element(boundBy: 0)) {
                    try takeScreenshot(name: "all_items_detail")
                    goBack()
                }
            }
            
            // Look for add buttons or plus buttons
            let addButtons = app.buttons.matching(NSPredicate(format: "label CONTAINS '+' OR label CONTAINS 'Add'"))
            if addButtons.count > 0 && safeTap(addButtons.firstMatch) {
                try takeScreenshot(name: "all_items_add_new")
                goBack()
            }
        }
        
        // 3. Today Tab
        let todayTab = app.tabBars.buttons["Today"]
        if safeTap(todayTab) {
            try takeScreenshot(name: "today_main")
            
            // Look for shift-related buttons
            if safeTap(app.buttons.containing(NSPredicate(format: "label CONTAINS 'Shift'")).firstMatch) {
                try takeScreenshot(name: "today_shift_detail")
                goBack()
            }
            
            // Look for time blocks or payoff queue
            if safeTap(app.buttons.containing(NSPredicate(format: "label CONTAINS 'Time' OR label CONTAINS 'Block'")).firstMatch) {
                try takeScreenshot(name: "today_time_blocks")
                goBack()
            }
            
            // Look for payoff queue
            if safeTap(app.buttons.containing(NSPredicate(format: "label CONTAINS 'Payoff' OR label CONTAINS 'Queue'")).firstMatch) {
                try takeScreenshot(name: "today_payoff_queue")
                goBack()
            }
        }
        
        // 4. Settings Tab
        let settingsTab = app.tabBars.buttons["Settings"]
        if safeTap(settingsTab) {
            try takeScreenshot(name: "settings_main")
            
            // Navigate through common settings options
            let settingsOptions = [
                "Wage",
                "Pay Period",
                "Schedule", 
                "Regular",
                "Notifications",
                "Theme",
                "About"
            ]
            
            for option in settingsOptions {
                if safeTap(app.buttons.containing(NSPredicate(format: "label CONTAINS '\(option)'")).firstMatch) {
                    try takeScreenshot(name: "settings_\(option.lowercased().replacingOccurrences(of: " ", with: "_"))")
                    goBack()
                }
                
                // Also check for cells/rows
                if safeTap(app.cells.containing(NSPredicate(format: "label CONTAINS '\(option)'")).firstMatch) {
                    try takeScreenshot(name: "settings_\(option.lowercased().replacingOccurrences(of: " ", with: "_"))")
                    goBack()
                }
            }
        }
        
        // MARK: - Additional Navigation Attempts
        
        // Go back to Home and try more specific navigation
        safeTap(homeTab)
        
        // Look for floating action buttons or main action buttons
        let floatingButtons = app.buttons.matching(NSPredicate(format: "label CONTAINS 'plus' OR identifier CONTAINS 'plus' OR identifier CONTAINS 'add'"))
        for i in 0..<min(floatingButtons.count, 3) {
            if safeTap(floatingButtons.element(boundBy: i)) {
                try takeScreenshot(name: "add_item_\(i + 1)")
                goBack()
            }
        }
        
        // Try navigation bars and their buttons
        let navBars = app.navigationBars
        for i in 0..<min(navBars.count, 3) {
            let navBar = navBars.element(boundBy: i)
            let navButtons = navBar.buttons
            for j in 0..<min(navButtons.count, 2) {
                let button = navButtons.element(boundBy: j)
                if button.exists && button.isHittable && !button.label.contains("Back") {
                    if safeTap(button) {
                        try takeScreenshot(name: "nav_option_\(i)_\(j)")
                        goBack()
                    }
                }
            }
        }
        
        // Try to find and navigate to specific features mentioned in NavManager
        let specificFeatures = [
            "Goals",
            "Expenses", 
            "Shifts",
            "Allocations",
            "Time Blocks",
            "Pay Periods",
            "Stats",
            "Tags"
        ]
        
        // Check each tab for these features
        let allTabs = [homeTab, allTab, todayTab, settingsTab]
        
        for tab in allTabs {
            safeTap(tab)
            
            for feature in specificFeatures {
                // Try buttons
                if safeTap(app.buttons.containing(NSPredicate(format: "label CONTAINS '\(feature)'")).firstMatch) {
                    try takeScreenshot(name: "\(feature.lowercased().replacingOccurrences(of: " ", with: "_"))_view")
                    goBack()
                }
                
                // Try cells
                if safeTap(app.cells.containing(NSPredicate(format: "label CONTAINS '\(feature)'")).firstMatch) {
                    try takeScreenshot(name: "\(feature.lowercased().replacingOccurrences(of: " ", with: "_"))_list")
                    goBack()
                }
                
                // Try text elements that might be tappable
                if safeTap(app.staticTexts.containing(NSPredicate(format: "label CONTAINS '\(feature)'")).firstMatch) {
                    try takeScreenshot(name: "\(feature.lowercased().replacingOccurrences(of: " ", with: "_"))_detail")
                    goBack()
                }
            }
        }
        
        print("Screenshot automation complete! Captured \(screenshotCounter - 1) screenshots.")
    }
}
