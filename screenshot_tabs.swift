#!/usr/bin/env swift

import Foundation

// Simple script to take screenshots using iOS Simulator
// This bypasses the Xcode build issues

print("Starting screenshot automation...")

let simulatorCommands = [
    "xcrun simctl boot 'iPhone 16 Pro' || echo 'Simulator already booted'",
    "sleep 5",  // Wait for simulator to boot
    "xcrun simctl launch 'iPhone 16 Pro' vin.UltimateMoneyVisualizer",
    "sleep 3",  // Wait for app to launch
]

let screenshotCommands = [
    ("Home", "xcrun simctl io 'iPhone 16 Pro' screenshot ~/Downloads/tab_1_home.png"),
    ("All", "xcrun simctl io 'iPhone 16 Pro' screenshot ~/Downloads/tab_2_all.png"), 
    ("Today", "xcrun simctl io 'iPhone 16 Pro' screenshot ~/Downloads/tab_3_today.png"),
    ("Settings", "xcrun simctl io 'iPhone 16 Pro' screenshot ~/Downloads/tab_4_settings.png")
]

// Function to run shell commands
func shell(_ command: String) -> Int32 {
    let task = Process()
    task.launchPath = "/bin/zsh"
    task.arguments = ["-c", command]
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

// Boot simulator and launch app
for command in simulatorCommands {
    let result = shell(command)
    if result != 0 && !command.contains("||") {
        print("Command failed: \(command)")
    }
}

print("App should be launched. Please manually navigate to each tab and press Enter after each:")

// Take screenshots with manual navigation
for (tabName, command) in screenshotCommands {
    print("\n1. Navigate to the \(tabName) tab")
    print("2. Press Enter when ready to take screenshot")
    
    let _ = readLine() // Wait for user input
    
    let result = shell(command)
    if result == 0 {
        print("✓ Screenshot saved: tab_\(tabName.lowercased()).png")
    } else {
        print("✗ Failed to take screenshot for \(tabName)")
    }
}

print("\nScreenshot automation complete! Check your Downloads folder.")