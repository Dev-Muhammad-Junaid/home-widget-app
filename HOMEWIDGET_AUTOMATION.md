# iOS HomeWidget Automation System

## Overview

This automation system ensures that iOS Home Widget Extension files are automatically generated and maintained whenever FlutterFlow exports changes to your Flutter project. Since FlutterFlow doesn't include iOS widget extension files in their exports, this system fills that gap.

## How It Works

### 1. **FlutterFlow Integration**
- FlutterFlow pushes changes to the `flutterflow` branch
- GitHub Actions automatically detects the push and triggers the sync workflow

### 2. **Automatic iOS Widget Generation**
- The workflow runs the setup script to generate all necessary iOS widget files
- Creates SwiftUI views for Small, Medium, and Large widget sizes
- Configures App Groups for data sharing between Flutter app and widget
- Updates Flutter integration code for iOS compatibility

### 3. **Seamless Merge to Production**
- After generating widget files, automatically merges `flutterflow` → `main`
- Your production branch always has the latest FlutterFlow changes + iOS widget files

## Generated Files

### iOS Extension Files
```
ios/HomeWidgetExtension/
├── HomeWidgetExtension.swift      # SwiftUI widget implementation
├── Info.plist                    # Extension configuration
├── Intents.intentdefinition      # Widget configuration options
└── HomeWidgetExtension.entitlements # App Groups permissions
```

### Updated Configuration Files
- `ios/Runner/Runner.entitlements` - App Groups for data sharing
- `ios/Runner/Info.plist` - Cleaned up (removes incorrect NSExtension)
- `lib/custom_code/actions/home_screen_widget.dart` - iOS-compatible widget updates
- `lib/custom_code/actions/initialize_home_widget.dart` - iOS initialization

## Widget Features

### 🎨 **Multiple Sizes**
- **Small Widget**: Title, description, and timestamp
- **Medium Widget**: Enhanced layout with Flutter branding
- **Large Widget**: Detailed view with status indicators

### 📡 **Real-time Updates**
- Data synced via App Groups (`group.com.example.homewidget`)
- Timeline-based refresh every hour
- Updates when Flutter app saves widget data

### ⚙️ **User Configuration**
- Widget title and description configurable by user
- Intent-based configuration through iOS widget settings

## Manual Usage

### Regenerate iOS Widget Files
If you need to manually regenerate the iOS widget files:

1. Go to **Actions** tab in your GitHub repository
2. Select "**Ensure iOS Widget Files**" workflow
3. Click "**Run workflow**"
4. Check "Force regenerate" if you want to recreate all files
5. Click "**Run workflow**"

## Development Setup

### In Xcode
1. Open `ios/Runner.xcworkspace`
2. Add HomeWidgetExtension target:
   - File → New → Target
   - iOS → Widget Extension
   - Use existing files from `ios/HomeWidgetExtension/`
3. Configure App Groups in both targets:
   - Target Settings → Signing & Capabilities
   - Add "App Groups" capability
   - Enable `group.com.example.homewidget`

### Flutter Integration
The system automatically updates your Flutter code to support iOS:

```dart
// Initialize widget (call once at app startup)
await initializeHomeWidget();

// Update widget data
await homeScreenWidget(
  "My Title",           // Widget title
  "My Description",     // Widget description  
  42                    // Counter value
);
```

## Workflows

### 1. FlutterFlow Sync (`flutterflow-sync.yml`)
- **Trigger**: Push to `flutterflow` branch
- **Actions**: 
  - Generate iOS widget files
  - Commit widget files to `flutterflow` branch
  - Merge `flutterflow` → `main`

### 2. Manual iOS Widget Generator (`ensure-ios-widget-files.yml`)
- **Trigger**: Manual dispatch only
- **Actions**: Generate/regenerate iOS widget files
- **Options**: Force regenerate all files

## Troubleshooting

### Widget Not Updating
1. Check App Groups configuration in Xcode
2. Verify `group.com.example.homewidget` is enabled in both targets
3. Ensure Flutter app calls `HomeWidget.setAppGroupId('group.com.example.homewidget')`

### Build Errors in Xcode
1. Clean build folder (⌘+Shift+K)
2. Check target dependencies and linking
3. Verify all files are added to HomeWidgetExtension target

### GitHub Actions Failing
1. Check workflow logs for specific errors
2. Ensure `scripts/setup_homewidget_ios.sh` is executable
3. Verify branch protection rules allow automated merges

## Configuration

### App Group ID
Default: `group.com.example.homewidget`

To change:
1. Update `GROUP_ID` in `scripts/setup_homewidget_ios.sh`
2. Update Flutter code to use new group ID
3. Regenerate widget files

### Widget Branding
Customize widget appearance by editing:
- `ios/HomeWidgetExtension/HomeWidgetExtension.swift`
- Update colors, fonts, and layout in SwiftUI views

## Maintenance

The system is designed to be **zero-maintenance**:
- ✅ Automatically triggered by FlutterFlow exports
- ✅ Self-updating Flutter integration code
- ✅ Cross-platform compatible (Linux/macOS)
- ✅ Error handling and validation

## Security

- Uses GitHub Actions secrets for authentication
- App Groups provide secure data sharing
- No sensitive data exposed in widget files
- Follows iOS security best practices

---

## Quick Start

1. **No setup required** - automation works out of the box
2. **FlutterFlow exports** automatically trigger widget generation
3. **Widget appears** in iOS widget gallery after building in Xcode
4. **Customize** widget appearance and data as needed

🎉 **That's it!** Your iOS home widgets will stay in sync with every FlutterFlow export. 