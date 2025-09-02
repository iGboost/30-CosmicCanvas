# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CosmicCanvas is an iOS application written in Swift, targeting iPhone devices with iOS 18.4+. The project uses a programmatic UI approach without storyboards for the main interface (only LaunchScreen storyboard exists).

## Project Structure

```
CosmicCanvas/
├── App/                    # Application lifecycle and configuration
│   ├── AppDelegate.swift   # Main app delegate
│   ├── SceneDelegate.swift # Scene lifecycle management
│   └── Info.plist         # App configuration
├── Resources/             # Assets and resources
│   └── Assets.xcassets/   # App icons and colors
├── Storyboards/          # Interface Builder files
│   └── Base.lproj/LaunchScreen.storyboard
└── ViewController.swift   # Main view controller
```

## Common Development Commands

### Building the Project
```bash
# Build for simulator (Debug)
xcodebuild -scheme CosmicCanvas -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 15' build

# Build for device (Release)
xcodebuild -scheme CosmicCanvas -configuration Release -destination 'generic/platform=iOS' build

# Clean build folder
xcodebuild clean -scheme CosmicCanvas
```

### Running the Application
```bash
# Run on simulator
open CosmicCanvas.xcodeproj
# Then use Xcode's Run button or Cmd+R

# Launch simulator directly
xcrun simctl boot "iPhone 15"
xcrun simctl install booted CosmicCanvas.app
xcrun simctl launch booted com.bolpis.CosmicCanvas
```

### Testing
```bash
# Run tests (if/when test targets are added)
xcodebuild test -scheme CosmicCanvas -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Architecture Notes

- **Bundle ID**: com.bolpis.CosmicCanvas
- **Target Device**: iPhone only (TARGETED_DEVICE_FAMILY = 1)
- **Deployment Target**: iOS 18.4
- **Swift Version**: 5.0
- **UI Approach**: Programmatic UI (SceneDelegate creates window and sets ViewController as rootViewController)
- **App Lifecycle**: Uses scene-based lifecycle with SceneDelegate
- **Code Signing**: Automatic

## Key Implementation Details

- The app uses SceneDelegate for window management instead of AppDelegate
- Main UI is created programmatically in SceneDelegate:16
- No storyboard-based main interface (LaunchScreen only)
- Standard UIKit app structure with single view controller
- Project uses file system synchronized groups in Xcode project structure