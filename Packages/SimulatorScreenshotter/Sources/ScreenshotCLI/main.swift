// main.swift - ScreenshotCLI
// Created: 2025-08-18
// Purpose: Command-line interface for SimulatorScreenshotter package
// Usage: Run as standalone CLI tool for screenshot automation from terminal or build scripts

import ArgumentParser
import Foundation
import SimulatorScreenshotter

@main
struct ScreenshotCLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "screenshot-cli",
        abstract: "Automated iOS Simulator screenshot capture tool",
        discussion: """
        This tool automates screenshot capture from iOS Simulator for app documentation and testing.
        
        Examples:
          screenshot-cli com.example.MyApp
          screenshot-cli com.example.MyApp --output ~/Screenshots --device "iPhone 15 Pro"
          screenshot-cli com.example.MyApp --mode comprehensive --no-manual
        """,
        version: "1.0.0"
    )
    
    @Argument(help: "App bundle identifier to launch and screenshot")
    var appBundleId: String
    
    @Option(name: .shortAndLong, help: "Output directory for screenshots")
    var output: String?
    
    @Option(name: .shortAndLong, help: "iOS Simulator device name")
    var device: String = "iPhone 16 Pro"
    
    @Option(help: "Screenshot mode: quick, minimal, comprehensive")
    var mode: String = "quick"
    
    @Option(help: "File prefix for screenshots")
    var prefix: String = "screenshot"
    
    @Flag(name: .customLong("no-boot"), help: "Don't boot simulator automatically")
    var skipBoot = false
    
    @Flag(name: .customLong("no-launch"), help: "Don't launch app automatically")
    var skipLaunch = false
    
    @Flag(name: .customLong("no-manual"), help: "Skip manual navigation (automated mode)")
    var skipManual = false
    
    @Flag(name: .shortAndLong, help: "Verbose output")
    var verbose = false
    
    @Flag(help: "List available simulators and exit")
    var listDevices = false
    
    func run() throws {
        // Handle list devices flag
        if listDevices {
            try listAvailableDevices()
            return
        }
        
        // Validate simulator availability
        guard SimulatorScreenshotter.checkAvailability() else {
            print("❌ Error: xcrun simctl not found. Make sure Xcode Command Line Tools are installed.")
            throw ExitCode.failure
        }
        
        // Create configuration based on mode
        let config = try createConfiguration()
        
        // Run screenshot automation
        do {
            let screenshotter = SimulatorScreenshotter(config: config)
            try screenshotter.captureScreenshots()
            
            print("\n🎉 Screenshot automation completed successfully!")
            print("📁 Screenshots saved to: \(config.outputDirectory.path)")
            
        } catch let error as ScreenshotError {
            print("❌ Screenshot Error: \(error.localizedDescription)")
            throw ExitCode.failure
        } catch {
            print("❌ Unexpected error: \(error.localizedDescription)")
            throw ExitCode.failure
        }
    }
    
    private func createConfiguration() throws -> SimulatorConfig {
        let outputDir = output.map { URL(fileURLWithPath: $0) }
        
        switch mode.lowercased() {
        case "quick":
            return SimulatorConfig(
                deviceName: device,
                appBundleId: appBundleId,
                outputDirectory: outputDir,
                filePrefix: prefix,
                screens: ScreenConfig.defaultScreens,
                autoBootSimulator: !skipBoot,
                autoLaunchApp: !skipLaunch,
                manualNavigation: !skipManual,
                verbose: verbose
            )
            
        case "minimal":
            return SimulatorConfig(
                deviceName: device,
                appBundleId: appBundleId,
                outputDirectory: outputDir,
                filePrefix: prefix,
                screens: ScreenConfig.minimalScreens,
                autoBootSimulator: !skipBoot,
                autoLaunchApp: !skipLaunch,
                manualNavigation: false, // Always automated for minimal
                verbose: verbose
            )
            
        case "comprehensive":
            return SimulatorConfig(
                deviceName: device,
                appBundleId: appBundleId,
                outputDirectory: outputDir,
                filePrefix: prefix,
                screens: ScreenConfig.comprehensiveScreens,
                autoBootSimulator: !skipBoot,
                autoLaunchApp: !skipLaunch,
                appLaunchDelay: 5,
                manualNavigation: !skipManual,
                verbose: verbose
            )
            
        default:
            print("❌ Invalid mode: \(mode). Use 'quick', 'minimal', or 'comprehensive'")
            throw ExitCode.validationFailure
        }
    }
    
    private func listAvailableDevices() throws {
        print("📱 Available iOS Simulators:")
        
        let simulators = try SimulatorScreenshotter.listAvailableSimulators()
        if simulators.isEmpty {
            print("No simulators found. Make sure Xcode is installed.")
        } else {
            for simulator in simulators {
                print("  • \(simulator)")
            }
        }
    }
}

// MARK: - Helper Extensions

extension ScreenshotCLI {
    static func printUsageExamples() {
        print("""
        
        📖 Usage Examples:
        
        Basic usage:
          screenshot-cli com.example.MyApp
        
        Custom output directory:
          screenshot-cli com.example.MyApp --output ~/Desktop/Screenshots
        
        Specific device:
          screenshot-cli com.example.MyApp --device "iPhone 15 Pro Max"
        
        Comprehensive mode with custom prefix:
          screenshot-cli com.example.MyApp --mode comprehensive --prefix "v1.0"
        
        Automated mode (no manual navigation):
          screenshot-cli com.example.MyApp --no-manual
        
        CI/CD friendly (minimal + automated):
          screenshot-cli com.example.MyApp --mode minimal --no-manual --output ./screenshots
        
        List available devices:
          screenshot-cli --list-devices
        
        """)
    }
}