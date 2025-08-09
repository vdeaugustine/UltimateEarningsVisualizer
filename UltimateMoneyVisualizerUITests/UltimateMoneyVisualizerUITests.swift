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
        
        // Tab identifiers based on the ContentView structure
        let tabs = [
            ("Home", "house"),
            ("All", "dollarsign"), 
            ("Today", "bolt.shield"),
            ("Settings", "gear")
        ]
        
        // Use the host machine's Downloads directory instead of simulator's sandboxed directory
        let downloadsPath = URL(fileURLWithPath: "/Users/vincentdeaugustine/Downloads")
        
        for (index, tab) in tabs.enumerated() {
            // Tap the tab
            let tabButton = app.tabBars.buttons[tab.0]
            XCTAssertTrue(tabButton.exists, "Tab \(tab.0) should exist")
            tabButton.tap()
            
            // Wait for content to load
            sleep(2)
            
            // Take screenshot
            let screenshot = app.screenshot()
            let fileName = "tab_\(index + 1)_\(tab.0.lowercased()).png"
            let fileURL = downloadsPath.appendingPathComponent(fileName)
            
            try screenshot.pngRepresentation.write(to: fileURL)
            print("Screenshot saved: \(fileURL.path)")
        }
    }
}
