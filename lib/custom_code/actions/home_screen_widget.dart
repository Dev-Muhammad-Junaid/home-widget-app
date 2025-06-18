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
