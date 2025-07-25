import 'package:flutter/material.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  String _appGroupid = 'group.homeScreenApp';
  String get appGroupid => _appGroupid;
  set appGroupid(String value) {
    _appGroupid = value;
  }

  String _IOSWidgetName = 'MyHomeWidget';
  String get IOSWidgetName => _IOSWidgetName;
  set IOSWidgetName(String value) {
    _IOSWidgetName = value;
  }

  String _androidWidgetName = 'MyHomeWidget';
  String get androidWidgetName => _androidWidgetName;
  set androidWidgetName(String value) {
    _androidWidgetName = value;
  }

  String _dataKey = 'data_from_flutter_app';
  String get dataKey => _dataKey;
  set dataKey(String value) {
    _dataKey = value;
  }
}
