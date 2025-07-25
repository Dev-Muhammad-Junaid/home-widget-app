#!/bin/bash
set -e

# Enhanced iOS HomeWidget Extension Setup Script
# This script creates all necessary files for iOS Home Widget Extension
# that are not included in FlutterFlow exports

echo "🚀 Starting iOS HomeWidget Extension Setup..."

# Configurable variables
GROUP_ID="group.com.example.homewidget"
EXTENSION_NAME="HomeWidgetExtension"
EXTENSION_DIR="ios/$EXTENSION_NAME"
RUNNER_ENTITLEMENTS="ios/Runner/Runner.entitlements"
RUNNER_INFO_PLIST="ios/Runner/Info.plist"

# Create extension directory
echo "📁 Creating extension directory: $EXTENSION_DIR"
mkdir -p "$EXTENSION_DIR"

# 1. Create HomeWidgetExtension.swift
echo "🎯 Creating HomeWidgetExtension.swift..."
cat > "$EXTENSION_DIR/$EXTENSION_NAME.swift" <<'EOF'
import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), title: "Home Widget", description: "Your Flutter app widget")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, title: "Home Widget", description: "Your Flutter app widget")
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Get data from UserDefaults (shared with Flutter app)
        let userDefaults = UserDefaults(suiteName: "group.com.example.homewidget")
        let title = userDefaults?.string(forKey: "widget_title") ?? "Home Widget"
        let description = userDefaults?.string(forKey: "widget_description") ?? "Your Flutter app widget"

        // Generate a timeline consisting of entries every hour for the next 5 hours.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, title: title, description: description)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let title: String
    let description: String
}

struct HomeWidgetExtensionEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

struct SmallWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .lineLimit(2)
            
            Spacer()
            
            Text(entry.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            Spacer()
            
            HStack {
                Spacer()
                Text(entry.date, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct MediumWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(entry.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(4)
                
                Spacer()
                
                Text("Updated: \(entry.date, style: .time)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack {
                Image(systemName: "house.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.accentColor)
                
                Text("Flutter")
                    .font(.caption)
                    .fontWeight(.medium)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct LargeWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(entry.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "house.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.accentColor)
            }
            
            Text(entry.description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(6)
            
            Spacer()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Status")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Active")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Last Updated")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(entry.date, style: .time)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
            .padding(.top)
        }
        .padding()
        .background(Color(.systemBackground))
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

@main
struct HomeWidgetExtension: Widget {
    let kind: String = "HomeWidgetExtension"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            HomeWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("Home Widget")
        .description("Display information from your Flutter app.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

#Preview(as: .systemSmall) {
    HomeWidgetExtension()
} timeline: {
    SimpleEntry(date: .now, configuration: ConfigurationIntent(), title: "Preview Title", description: "Preview description for the home widget")
}
EOF

# 2. Create Info.plist
echo "📄 Creating Info.plist..."
cat > "$EXTENSION_DIR/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>\$(DEVELOPMENT_LANGUAGE)</string>
	<key>CFBundleDisplayName</key>
	<string>Home Widget</string>
	<key>CFBundleExecutable</key>
	<string>\$(EXECUTABLE_NAME)</string>
	<key>CFBundleIdentifier</key>
	<string>\$(PRODUCT_BUNDLE_IDENTIFIER)</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>\$(PRODUCT_NAME)</string>
	<key>CFBundlePackageType</key>
	<string>\$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
	<key>CFBundleShortVersionString</key>
	<string>1.0</string>
	<key>CFBundleVersion</key>
	<string>1</string>
	<key>NSExtension</key>
	<dict>
		<key>NSExtensionPointIdentifier</key>
		<string>com.apple.widgetkit-extension</string>
	</dict>
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoads</key>
		<true/>
	</dict>
</dict>
</plist>
EOF

# 3. Create Intents.intentdefinition
echo "🎛️ Creating Intents.intentdefinition..."
cat > "$EXTENSION_DIR/Intents.intentdefinition" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>INEnums</key>
	<array/>
	<key>INIntentDefinitionModelVersion</key>
	<string>1.2</string>
	<key>INIntentDefinitionNamespace</key>
	<string>88xZPY</string>
	<key>INIntentDefinitionSystemVersion</key>
	<string>21A559</string>
	<key>INIntents</key>
	<array>
		<dict>
			<key>INIntentCategory</key>
			<string>information</string>
			<key>INIntentConfigurable</key>
			<true/>
			<key>INIntentDescriptionID</key>
			<string>pzTlbF</string>
			<key>INIntentEligibleForWidgets</key>
			<true/>
			<key>INIntentIneligibleForSuggestions</key>
			<true/>
			<key>INIntentName</key>
			<string>Configuration</string>
			<key>INIntentParameters</key>
			<array>
				<dict>
					<key>INIntentParameterConfigurable</key>
					<true/>
					<key>INIntentParameterDisplayName</key>
					<string>Widget Title</string>
					<key>INIntentParameterDisplayNameID</key>
					<string>6kL2oG</string>
					<key>INIntentParameterName</key>
					<string>widgetTitle</string>
					<key>INIntentParameterSupportsResolution</key>
					<true/>
					<key>INIntentParameterTag</key>
					<integer>1</integer>
					<key>INIntentParameterType</key>
					<string>String</string>
				</dict>
				<dict>
					<key>INIntentParameterConfigurable</key>
					<true/>
					<key>INIntentParameterDisplayName</key>
					<string>Widget Description</string>
					<key>INIntentParameterDisplayNameID</key>
					<string>7mN3pH</string>
					<key>INIntentParameterName</key>
					<string>widgetDescription</string>
					<key>INIntentParameterSupportsResolution</key>
					<true/>
					<key>INIntentParameterTag</key>
					<integer>2</integer>
					<key>INIntentParameterType</key>
					<string>String</string>
				</dict>
			</array>
			<key>INIntentResponse</key>
			<dict>
				<key>INIntentResponseCodes</key>
				<array>
					<dict>
						<key>INIntentResponseCodeName</key>
						<string>success</string>
						<key>INIntentResponseCodeSuccess</key>
						<true/>
					</dict>
					<dict>
						<key>INIntentResponseCodeName</key>
						<string>failure</string>
					</dict>
				</array>
			</dict>
			<key>INIntentTitle</key>
			<string>Configuration</string>
			<key>INIntentTitleID</key>
			<string>gpCwrM</string>
			<key>INIntentType</key>
			<string>Custom</string>
			<key>INIntentVerb</key>
			<string>unknown</string>
		</dict>
	</array>
	<key>INTypes</key>
	<array/>
</dict>
</plist>
EOF

# 4. Create HomeWidgetExtension.entitlements
echo "🔐 Creating HomeWidgetExtension.entitlements..."
cat > "$EXTENSION_DIR/$EXTENSION_NAME.entitlements" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.security.application-groups</key>
	<array>
		<string>$GROUP_ID</string>
	</array>
</dict>
</plist>
EOF

# 5. Update or create Runner.entitlements
echo "📝 Updating Runner.entitlements..."
if [ -f "$RUNNER_ENTITLEMENTS" ]; then
    # Check if App Groups already exist
    if ! grep -q "com.apple.security.application-groups" "$RUNNER_ENTITLEMENTS"; then
        # Add App Groups to existing entitlements
        # Remove closing </dict> and </plist> (compatible with both Linux and macOS)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS version
            sed -i '' '/<\/dict>/d' "$RUNNER_ENTITLEMENTS"
            sed -i '' '/<\/plist>/d' "$RUNNER_ENTITLEMENTS"
        else
            # Linux version (GitHub Actions)
            sed -i '/<\/dict>/d' "$RUNNER_ENTITLEMENTS"
            sed -i '/<\/plist>/d' "$RUNNER_ENTITLEMENTS"
        fi
        
        # Add App Groups section
        cat >> "$RUNNER_ENTITLEMENTS" <<EOF
	<key>com.apple.security.application-groups</key>
	<array>
		<string>$GROUP_ID</string>
	</array>
</dict>
</plist>
EOF
    else
        echo "   App Groups already configured in Runner.entitlements"
    fi
else
    # Create new entitlements file
    cat > "$RUNNER_ENTITLEMENTS" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>aps-environment</key>
	<string>development</string>
	<key>com.apple.security.app-sandbox</key>
	<true/>
	<key>com.apple.security.application-groups</key>
	<array>
		<string>$GROUP_ID</string>
	</array>
	<key>com.apple.security.get-task-allow</key>
	<true/>
	<key>com.apple.security.network.client</key>
	<true/>
</dict>
</plist>
EOF
fi

# 6. Fix Runner Info.plist (remove NSExtension if present)
echo "🔧 Fixing Runner Info.plist..."
if [ -f "$RUNNER_INFO_PLIST" ]; then
    # Remove NSExtension section if it exists (should only be in widget extension)
    if grep -q "NSExtension" "$RUNNER_INFO_PLIST"; then
        echo "   Removing incorrect NSExtension from main app Info.plist"
        # Use sed to remove NSExtension block (compatible with both Linux and macOS)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS version
            sed -i '' '/<key>NSExtension<\/key>/,/<\/dict>/d' "$RUNNER_INFO_PLIST"
        else
            # Linux version (GitHub Actions)
            sed -i '/<key>NSExtension<\/key>/,/<\/dict>/d' "$RUNNER_INFO_PLIST"
        fi
    fi
fi

# 7. Update Flutter integration files
echo "📱 Updating Flutter integration files..."

# Update home_screen_widget.dart if it exists
FLUTTER_WIDGET_FILE="lib/custom_code/actions/home_screen_widget.dart"
if [ -f "$FLUTTER_WIDGET_FILE" ]; then
    # Check if it needs updating for iOS support
    if ! grep -q "setAppGroupId.*$GROUP_ID" "$FLUTTER_WIDGET_FILE"; then
        echo "   Updating Flutter widget integration for iOS..."
        # Backup original
        cp "$FLUTTER_WIDGET_FILE" "$FLUTTER_WIDGET_FILE.backup"
        
        # Update the function to include iOS support
        cat > "$FLUTTER_WIDGET_FILE" <<'FLUTTER_EOF'
// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:home_widget/home_widget.dart';

Future homeScreenWidget(
  String? title,
  String? message,
  int? count,
) async {
  try {
    // Configure app group for iOS (required for data sharing with widget extension)
    await HomeWidget.setAppGroupId('group.com.example.homewidget');
    
    // Save widget data with iOS-compatible keys
    if (title != null) {
      await HomeWidget.saveWidgetData<String>('widget_title', title);
    }

    if (message != null) {
      await HomeWidget.saveWidgetData<String>('widget_description', message);
    }

    if (count != null) {
      await HomeWidget.saveWidgetData<int>('widget_count', count);
    }

    // Save timestamp for "last updated"
    await HomeWidget.saveWidgetData<String>(
        'widget_last_updated', DateTime.now().toIso8601String());

    // Save additional data for different widget sizes
    await HomeWidget.saveWidgetData<String>(
        'widget_status', 'Active');
    
    await HomeWidget.saveWidgetData<String>(
        'widget_updated_time', 
        DateTime.now().toString().split(' ').last.substring(0, 5)); // HH:MM format

    // Update the widget on both platforms
    await HomeWidget.updateWidget(
      name: 'HomeWidgetExtension', // Android widget name
      iOSName: 'HomeWidgetExtension', // iOS widget name (matches our extension)
      androidName: 'HomeWidgetExtension', // Android widget name
    );

    print('HomeWidget updated successfully');
    print('Title: $title');
    print('Message: $message');
    print('Count: $count');
  } catch (e) {
    print('Error updating HomeWidget: $e');
    throw e;
  }
}
FLUTTER_EOF
    fi
fi

# Update initialize_home_widget.dart if it exists
FLUTTER_INIT_FILE="lib/custom_code/actions/initialize_home_widget.dart"
if [ -f "$FLUTTER_INIT_FILE" ]; then
    # Check if it needs updating for iOS support
    if ! grep -q "setAppGroupId.*$GROUP_ID" "$FLUTTER_INIT_FILE"; then
        echo "   Updating Flutter widget initialization for iOS..."
        # Backup original
        cp "$FLUTTER_INIT_FILE" "$FLUTTER_INIT_FILE.backup"
        
        # Update the function to include iOS support
        cat > "$FLUTTER_INIT_FILE" <<'FLUTTER_INIT_EOF'
// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:home_widget/home_widget.dart';

Future initializeHomeWidget() async {
  try {
    // Set app group ID for iOS (must match the entitlements)
    await HomeWidget.setAppGroupId('group.com.example.homewidget');
    
    // Register callback for widget interactions (iOS)
    HomeWidget.registerInteractivityCallback(backgroundCallback);
    
    // Initialize with default values
    await HomeWidget.saveWidgetData<String>('widget_title', 'Home Widget');
    await HomeWidget.saveWidgetData<String>('widget_description', 'Your Flutter app widget');
    await HomeWidget.saveWidgetData<int>('widget_count', 0);
    await HomeWidget.saveWidgetData<String>('widget_status', 'Initialized');
    await HomeWidget.saveWidgetData<String>(
        'widget_last_updated', DateTime.now().toIso8601String());
    
    print('HomeWidget initialized successfully');
  } catch (e) {
    print('Error initializing HomeWidget: $e');
    throw e;
  }
}

// Callback function for widget interactions
Future<void> backgroundCallback(Uri uri) async {
  print('Widget interaction: $uri');
  // Handle widget tap events here
  // You can perform background tasks or save data to be processed when app opens
}
FLUTTER_INIT_EOF
    fi
fi

# 8. Create configuration file
echo "⚙️ Creating configuration file..."
cat > "homewidget-config.env" <<EOF
# HomeWidget Configuration
# This file is auto-generated by setup_homewidget_ios.sh

# App Group ID (must match in entitlements)
GROUP_ID=$GROUP_ID

# Extension name
EXTENSION_NAME=$EXTENSION_NAME

# Extension directory
EXTENSION_DIR=$EXTENSION_DIR

# Generation timestamp
GENERATED_AT=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Flutter Integration Status
FLUTTER_INTEGRATION=enabled
EOF

echo ""
echo "✅ iOS HomeWidget Extension setup completed successfully!"
echo ""
echo "📋 Summary of files created/updated:"
echo "   - $EXTENSION_DIR/$EXTENSION_NAME.swift"
echo "   - $EXTENSION_DIR/Info.plist"
echo "   - $EXTENSION_DIR/Intents.intentdefinition"
echo "   - $EXTENSION_DIR/$EXTENSION_NAME.entitlements"
echo "   - $RUNNER_ENTITLEMENTS (updated/created)"
echo "   - homewidget-config.env"
echo ""
echo "📱 Flutter integration files updated:"
[ -f "$FLUTTER_WIDGET_FILE" ] && echo "   - $FLUTTER_WIDGET_FILE"
[ -f "$FLUTTER_INIT_FILE" ] && echo "   - $FLUTTER_INIT_FILE"
echo ""
echo "🎯 Next steps:"
echo "   1. Open ios/Runner.xcworkspace in Xcode"
echo "   2. Add HomeWidgetExtension target to your project"
echo "   3. Configure App Groups in both targets"
echo "   4. Build and test your widget!"
echo ""
echo "🔗 App Group ID: $GROUP_ID"
echo "📦 Extension Name: $EXTENSION_NAME"