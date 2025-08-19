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
    // Save widget data
    if (title != null) {
      await HomeWidget.saveWidgetData<String>('title', title);
    }

    if (message != null) {
      await HomeWidget.saveWidgetData<String>('message', message);
    }

    if (count != null) {
      await HomeWidget.saveWidgetData<int>('count', count);
    }

    // Save timestamp for "last updated"
    await HomeWidget.saveWidgetData<String>(
        'lastUpdated', DateTime.now().toIso8601String());

    // Update the widget on both platforms
    await HomeWidget.updateWidget(
      name: 'HomeWidget', // Android widget name
      iOSName: 'HomeWidget', // iOS widget name
      androidName: 'HomeWidget', // Android widget name (alternative)
    );

    print('HomeWidget updated successfully');
  } catch (e) {
    print('Error updating HomeWidget: $e');
    throw e;
  }
}
