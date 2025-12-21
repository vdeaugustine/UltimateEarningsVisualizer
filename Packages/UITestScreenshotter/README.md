# UITestScreenshotter

A Swift package for automated screenshot capture during iOS UI testing. Automatically explores your entire app and captures comprehensive screenshots for documentation, testing, and App Store assets.

## Features

- 🤖 **Fully Automated**: No manual navigation required
- 📱 **Tab-Based & Single-View Apps**: Handles both navigation patterns
- 🔍 **Smart Exploration**: Finds buttons, cells, and features automatically
- ⚙️ **Highly Configurable**: Customize behavior for your specific app
- 📁 **Flexible Output**: Save to any directory with custom naming
- 🎯 **Feature Detection**: Searches for specific app features by name
- 🧪 **XCTest Integration**: Works seamlessly with existing UI tests

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/UITestScreenshotter", from: "1.0.0")
]
```

Or add via Xcode:
1. File → Add Package Dependencies
2. Enter package URL
3. Add to your UI Test target

## Quick Start

### Basic Usage

Add to your UI test:

```swift
import XCTest
import UITestScreenshotter

class MyAppUITests: XCTestCase {
    func testScreenshotAllScreens() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Capture all screenshots automatically
        try UITestScreenshotter.captureApp(app)
    }
}
```

### Custom Output Directory

```swift
func testScreenshotToCustomPath() throws {
    let app = XCUIApplication()
    app.launch()
    
    try UITestScreenshotter.captureApp(app, outputPath: "/Users/username/Desktop/Screenshots")
}
```

### Comprehensive Capture

```swift
func testComprehensiveScreenshots() throws {
    let app = XCUIApplication()
    app.launch()
    
    // Captures 20-50+ screenshots with extensive exploration
    try UITestScreenshotter.captureComprehensive(app, outputPath: "~/Desktop/AppScreenshots")
}
```

## Advanced Configuration

### Custom Configuration

```swift
func testCustomConfiguration() throws {
    let app = XCUIApplication()
    app.launch()
    
    let config = ScreenshotConfiguration(
        outputDirectory: URL(fileURLWithPath: "/path/to/screenshots"),
        tabNames: ["Home", "Search", "Profile", "Settings"],
        featureNames: ["Goals", "Analytics", "Export", "Sync"],
        screenshotDelay: 3,
        elementTimeout: 10.0,
        maxNavigationAttempts: 5,
        verbose: true
    )
    
    let screenshotter = UITestScreenshotter(app: app, config: config)
    try screenshotter.captureAllScreenshots()
}
```

### Predefined Configurations

```swift
// Minimal capture (faster, fewer screenshots)
try UITestScreenshotter.captureMinimal(app, outputPath: "~/Screenshots")

// Comprehensive capture (thorough exploration)
try UITestScreenshotter.captureComprehensive(app, outputPath: "~/Screenshots")
```

## Configuration Options

### ScreenshotConfiguration

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `outputDirectory` | `URL` | `~/Downloads` | Where to save screenshots |
| `tabNames` | `[String]` | `["Home", "All", "Today", "Settings"]` | Tab names to look for |
| `featureNames` | `[String]` | `["Goals", "Expenses", ...]` | Features to search for |
| `screenshotDelay` | `UInt32` | `2` | Wait time between screenshots (seconds) |
| `elementTimeout` | `Double` | `5.0` | Element wait timeout (seconds) |
| `maxNavigationAttempts` | `Int` | `3` | Max navigation attempts per section |
| `verbose` | `Bool` | `true` | Enable detailed logging |
| `appBundleId` | `String?` | `nil` | Specific app bundle ID |

## Screenshot Naming

Screenshots are automatically named with:
- **Sequential numbering**: `01_`, `02_`, `03_`...
- **Descriptive names**: `home_main`, `settings_profile`, `add_new_item`
- **PNG format**: All screenshots saved as `.png` files

Example output:
```
01_home_main.png
02_home_stats.png
03_all_items_main.png
04_all_items_detail.png
05_today_main.png
06_settings_main.png
```

## What Gets Captured

### Automatic Exploration
- ✅ All tab bar tabs
- ✅ Navigation bar buttons
- ✅ Floating action buttons (`+`, `Add`)
- ✅ List cells and detail views
- ✅ Settings and configuration screens
- ✅ Feature-specific screens (based on `featureNames`)

### Smart Navigation
- ✅ Automatically goes back after each screenshot
- ✅ Handles modal presentations
- ✅ Skips broken or inaccessible elements
- ✅ Respects element visibility and interactivity

## Integration Examples

### CI/CD Pipeline

```swift
// Fast, reliable screenshots for CI
func testCIScreenshots() throws {
    let app = XCUIApplication()
    app.launch()
    
    let config = ScreenshotConfiguration.minimal(outputPath: "./build/screenshots")
    let screenshotter = UITestScreenshotter(app: app, config: config)
    try screenshotter.captureAllScreenshots()
}
```

### App Store Screenshots

```swift
// High-quality screenshots for App Store
func testAppStoreScreenshots() throws {
    let app = XCUIApplication()
    app.launch()
    
    let config = ScreenshotConfiguration(
        outputDirectory: URL(fileURLWithPath: "./AppStoreScreenshots"),
        tabNames: ["Home", "Features", "Settings"],
        screenshotDelay: 3, // Extra time for animations
        verbose: false
    )
    
    let screenshotter = UITestScreenshotter(app: app, config: config)
    try screenshotter.captureAllScreenshots()
}
```

### Documentation Generation

```swift
// Comprehensive screenshots for documentation
func testDocumentationScreenshots() throws {
    let app = XCUIApplication()
    app.launch()
    
    try UITestScreenshotter.captureComprehensive(
        app, 
        outputPath: "~/Documents/AppDocumentation/Screenshots"
    )
}
```

## Best Practices

### Test Setup
```swift
override func setUpWithError() throws {
    continueAfterFailure = false
    
    let app = XCUIApplication()
    // Set any required launch arguments or environment variables
    app.launchArguments = ["--uitesting"]
    app.launchEnvironment = ["SCREENSHOTS_MODE": "true"]
}
```

### Error Handling
```swift
func testScreenshotsWithErrorHandling() throws {
    let app = XCUIApplication()
    app.launch()
    
    do {
        try UITestScreenshotter.captureApp(app)
    } catch ScreenshotError.elementNotFound {
        // Handle specific screenshot errors
        XCTFail("Could not find expected UI elements")
    } catch {
        XCTFail("Screenshot automation failed: \(error)")
    }
}
```

## Troubleshooting

### Common Issues

**Screenshots are empty or black:**
- Increase `screenshotDelay` to allow UI to load
- Check if app requires specific launch arguments

**Missing screenshots:**
- Verify `tabNames` match your app's tabs
- Add custom `featureNames` for your app's specific features
- Increase `elementTimeout` for slow-loading screens

**Too many/few screenshots:**
- Use `ScreenshotConfiguration.minimal()` for fewer screenshots
- Use `ScreenshotConfiguration.comprehensive()` for more coverage
- Customize `maxNavigationAttempts` to control exploration depth

### Debug Logging

Enable verbose logging:
```swift
let config = ScreenshotConfiguration(verbose: true)
```

This will output detailed information about:
- Which elements are being found/tapped
- Screenshot save locations
- Navigation success/failure
- Timing information

## Requirements

- iOS 13.0+
- Xcode 14.0+
- XCTest framework

## License

MIT License - see LICENSE file for details.