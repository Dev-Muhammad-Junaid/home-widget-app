#!/bin/bash
set -e

echo "🛠️  Adding HomeWidget Extension to Xcode Project..."

PROJECT_FILE="ios/Runner.xcodeproj/project.pbxproj"
BACKUP_FILE="ios/Runner.xcodeproj/project.pbxproj.backup"

# Create backup
echo "📦 Creating backup of project.pbxproj..."
cp "$PROJECT_FILE" "$BACKUP_FILE"

# Check if HomeWidgetExtension target already exists
if grep -q "HomeWidgetExtension" "$PROJECT_FILE"; then
    echo "⚠️  HomeWidgetExtension target already exists in the project."
    echo "    Please manually verify it's configured correctly in Xcode."
    exit 0
fi

echo "➕ Adding HomeWidgetExtension target to Xcode project..."

# This is a complex modification that's better done manually in Xcode
# For now, let's provide clear instructions

cat << 'INSTRUCTIONS'

🎯 MANUAL STEPS REQUIRED:

The widget extension files are ready, but they need to be added to Xcode manually.
Follow these steps EXACTLY:

1. Open Xcode: ios/Runner.xcworkspace (should already be open)

2. Add Widget Extension Target:
   - Select "Runner" project (blue icon at top)
   - Click "+" button at bottom of targets list
   - Choose "Widget Extension"
   - Product Name: HomeWidgetExtension
   - Bundle Identifier: com.mycompany.homewidget.HomeWidgetExtension
   - Include Configuration Intent: ✅ CHECK THIS
   - Click "Finish"
   - When prompted "Activate scheme?": Click "Cancel"

3. Replace Generated Files:
   - Delete generated: HomeWidgetExtension.swift, Intents.intentdefinition, Info.plist
   - Right-click HomeWidgetExtension folder → "Add Files to Runner"
   - Select ALL files from ios/HomeWidgetExtension/
   - ✅ CHECK "Add to target: HomeWidgetExtension"
   - Click "Add"

4. Configure App Groups:
   - Runner target → Signing & Capabilities → + Capability → App Groups
   - Add: group.com.example.homewidget
   
   - HomeWidgetExtension target → Signing & Capabilities → + Capability → App Groups  
   - Add: group.com.example.homewidget

5. Clean & Build:
   - Product → Clean Build Folder
   - Product → Build

6. Run on device and add widget!

INSTRUCTIONS

echo ""
echo "✅ Files are ready! Please follow the manual steps above in Xcode."
echo "📁 Extension files location: ios/HomeWidgetExtension/"
echo "🔧 App Group ID: group.com.example.homewidget" 