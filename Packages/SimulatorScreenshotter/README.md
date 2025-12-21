# SimulatorScreenshotter

A Swift package and CLI tool for controlled screenshot capture via iOS Simulator. Perfect for manual navigation scenarios, CI/CD pipelines, and when you need precise control over which screens to capture.

## Features

- 🖥️ **CLI Tool**: Use from terminal or build scripts
- 📦 **Swift Package**: Integrate into your Swift projects
- 🎮 **Manual Control**: Navigate manually for perfect screenshots
- 🤖 **Automation Options**: Fully automated mode available
- 📱 **Device Selection**: Support for any iOS Simulator device
- ⚙️ **Highly Configurable**: Customize everything from output to timing
- 🚀 **CI/CD Ready**: Perfect for automated documentation workflows

## Installation

### As CLI Tool

```bash
# Clone and build
git clone https://github.com/yourusername/SimulatorScreenshotter
cd SimulatorScreenshotter
swift build -c release

# Copy to your PATH
cp .build/release/screenshot-cli /usr/local/bin/
```

### As Swift Package

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/SimulatorScreenshotter", from: "1.0.0")
]
```

## Quick Start

### CLI Usage

```bash
# Basic usage
screenshot-cli com.example.MyApp

# Custom output directory
screenshot-cli com.example.MyApp --output ~/Desktop/Screenshots

# Specific device
screenshot-cli com.example.MyApp --device "iPhone 15 Pro Max"

# Comprehensive mode
screenshot-cli com.example.MyApp --mode comprehensive

# Fully automated (no manual navigation)
screenshot-cli com.example.MyApp --no-manual
```

### Swift Package Usage

```swift
import SimulatorScreenshotter

// Quick capture with manual navigation
try SimulatorScreenshotter.captureQuick(
    appBundleId: "com.example.MyApp",
    outputPath: "~/Desktop/Screenshots"
)

// Minimal automated capture
try SimulatorScreenshotter.captureMinimal(
    appBundleId: "com.example.MyApp"
)

// Comprehensive manual capture
try SimulatorScreenshotter.captureComprehensive(
    appBundleId: "com.example.MyApp"
)
```

## CLI Reference

### Basic Commands

```bash
screenshot-cli <APP_BUNDLE_ID> [OPTIONS]
```

### Options

| Option | Short | Description | Default |
|--------|-------|-------------|---------|
| `--output` | `-o` | Output directory | `~/Downloads` |
| `--device` | `-d` | iOS Simulator device name | `iPhone 16 Pro` |
| `--mode` | | Screenshot mode: `quick`, `minimal`, `comprehensive` | `quick` |
| `--prefix` | | File prefix for screenshots | `screenshot` |
| `--no-boot` | | Don't boot simulator automatically | Boot enabled |
| `--no-launch` | | Don't launch app automatically | Launch enabled |
| `--no-manual` | | Skip manual navigation (automated mode) | Manual enabled |
| `--verbose` | `-v` | Verbose output | False |
| `--list-devices` | | List available simulators and exit | |

### Examples

```bash
# List available devices
screenshot-cli --list-devices

# Basic app screenshots
screenshot-cli com.mycompany.MyApp

# Custom output with specific device
screenshot-cli com.mycompany.MyApp \
  --output ~/Desktop/AppScreenshots \
  --device "iPhone 15 Pro"

# Comprehensive mode with custom prefix
screenshot-cli com.mycompany.MyApp \
  --mode comprehensive \
  --prefix "v2.0" \
  --output ./documentation/screenshots

# CI/CD automated mode
screenshot-cli com.mycompany.MyApp \
  --mode minimal \
  --no-manual \
  --output ./build/screenshots \
  --verbose
```

## Modes

### Quick Mode (Default)
- 4 standard screens: Home, All Items, Today, Settings
- Manual navigation
- Good for most apps

### Minimal Mode
- 1 screen: Main view
- Automated navigation
- Perfect for CI/CD

### Comprehensive Mode
- 8+ screens: All main features
- Manual navigation with detailed instructions
- Best for thorough documentation

## Advanced Configuration

### Custom Swift Configuration

```swift
import SimulatorScreenshotter

let config = SimulatorConfig(
    deviceName: "iPhone 16 Pro",
    appBundleId: "com.example.MyApp",
    outputDirectory: URL(fileURLWithPath: "/path/to/screenshots"),
    filePrefix: "myapp",
    screens: [
        ScreenConfig(name: "Home", instructions: "Navigate to home screen"),
        ScreenConfig(name: "Profile", instructions: "Open user profile"),
        ScreenConfig(name: "Settings", instructions: "Go to app settings")
    ],
    autoBootSimulator: true,
    autoLaunchApp: true,
    appLaunchDelay: 5,
    manualNavigation: true,
    verbose: true
)

let screenshotter = SimulatorScreenshotter(config: config)
try screenshotter.captureScreenshots()
```

### Custom Screen Configurations

```swift
// Define custom screens
let customScreens = [
    ScreenConfig(
        name: "Dashboard", 
        instructions: "Navigate to the main dashboard",
        filename: "01_dashboard"
    ),
    ScreenConfig(
        name: "Analytics", 
        instructions: "Open analytics view",
        filename: "02_analytics"
    ),
    ScreenConfig(
        name: "Settings", 
        instructions: "Go to app settings",
        filename: "03_settings"
    )
]

let config = SimulatorConfig(
    appBundleId: "com.example.MyApp",
    screens: customScreens
)
```

## Configuration Options

### SimulatorConfig

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `deviceName` | `String` | `iPhone 16 Pro` | iOS Simulator device name |
| `appBundleId` | `String` | Required | App bundle identifier |
| `outputDirectory` | `URL` | `~/Downloads` | Screenshot output directory |
| `filePrefix` | `String` | `screenshot` | Filename prefix |
| `screens` | `[ScreenConfig]` | Default screens | Screens to capture |
| `autoBootSimulator` | `Bool` | `true` | Boot simulator automatically |
| `autoLaunchApp` | `Bool` | `true` | Launch app automatically |
| `appLaunchDelay` | `Int` | `3` | Wait time after app launch (seconds) |
| `manualNavigation` | `Bool` | `true` | Require manual navigation |
| `verbose` | `Bool` | `true` | Enable verbose logging |

### ScreenConfig

| Property | Type | Description |
|----------|------|-------------|
| `name` | `String` | Display name for the screen |
| `instructions` | `String` | Instructions shown to user |
| `filename` | `String` | Output filename (without extension) |

## Screenshot Output

### File Naming

Screenshots are saved with sequential numbering and descriptive names:

```
01_screenshot_home.png
02_screenshot_all_items.png
03_screenshot_today.png
04_screenshot_settings.png
```

### Custom Naming

```bash
# With custom prefix
screenshot-cli com.example.MyApp --prefix "v1.2"
# Output: 01_v1.2_home.png, 02_v1.2_all_items.png...

# With custom output directory
screenshot-cli com.example.MyApp --output ~/Desktop/MyAppScreenshots
# Saves to ~/Desktop/MyAppScreenshots/01_screenshot_home.png
```

## Integration Examples

### Build Script Integration

```bash
#!/bin/bash
# build-and-screenshot.sh

# Build the app
xcodebuild -project MyApp.xcodeproj -scheme MyApp -sdk iphonesimulator

# Generate screenshots
screenshot-cli com.example.MyApp \
  --mode comprehensive \
  --output ./build/screenshots \
  --prefix "v$(git describe --tags --abbrev=0)"

echo "Screenshots saved to ./build/screenshots"
```

### CI/CD Integration

```yaml
# GitHub Actions example
- name: Generate Screenshots
  run: |
    screenshot-cli com.example.MyApp \
      --mode minimal \
      --no-manual \
      --output ./screenshots \
      --verbose
      
- name: Upload Screenshots
  uses: actions/upload-artifact@v3
  with:
    name: app-screenshots
    path: ./screenshots/
```

### Xcode Build Phase

Add as a build phase script:

```bash
# Only run on Debug builds
if [ "${CONFIGURATION}" == "Debug" ]; then
    screenshot-cli "${PRODUCT_BUNDLE_IDENTIFIER}" \
      --mode quick \
      --output "${BUILT_PRODUCTS_DIR}/Screenshots" \
      --no-manual
fi
```

## Manual Navigation Mode

When using manual navigation, the tool will:

1. **Boot simulator** and launch your app
2. **Show instructions** for each screen:
   ```
   --- Screen 1: Home ---
   📱 Navigate to the Home tab
   ⏳ Press Enter when ready to take screenshot...
   ```
3. **Wait for Enter key** before taking each screenshot
4. **Provide feedback** on successful captures

This gives you perfect control over:
- App state and data
- Specific views and configurations
- Animation timing
- Modal presentations

## Automated Mode

For CI/CD and batch processing:

```bash
# Fully automated - no user input required
screenshot-cli com.example.MyApp --no-manual --mode minimal
```

Automated mode:
- ✅ Boots simulator automatically
- ✅ Launches app automatically
- ✅ Takes screenshots without user input
- ✅ Perfect for CI/CD pipelines

## Troubleshooting

### Common Issues

**Simulator not found:**
```bash
# List available simulators
screenshot-cli --list-devices

# Use exact device name
screenshot-cli com.example.MyApp --device "iPhone 15 Pro Max"
```

**App launch failed:**
- Verify bundle ID is correct
- Ensure app is installed in simulator
- Check app doesn't require specific launch conditions

**Screenshot capture failed:**
- Simulator must be booted and visible
- App must be in foreground
- Check disk space in output directory

### Debug Mode

```bash
# Enable verbose logging
screenshot-cli com.example.MyApp --verbose

# Check simulator status
xcrun simctl list devices
```

## Requirements

- macOS 10.15+
- Xcode Command Line Tools
- iOS Simulator
- Swift 5.9+

## License

MIT License - see LICENSE file for details.