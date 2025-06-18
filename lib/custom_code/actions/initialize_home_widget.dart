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
