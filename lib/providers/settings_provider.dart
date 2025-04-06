import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static const String _darkModeKey = 'darkMode';
  static const String _hapticFeedbackKey = 'hapticFeedback';
  static const String _motivationalQuotesKey = 'motivationalQuotes';
  static const String _distanceUnitKey = 'distanceUnit';
  static const String _weightUnitKey = 'weightUnit';

  late SharedPreferences _prefs;
  bool _isDarkMode = false;
  bool _useHapticFeedback = true;
  bool _showMotivationalQuotes = true;
  String _distanceUnit = 'km';
  String _weightUnit = 'kg';
  bool _isInitialized = false;

  bool get isDarkMode => _isDarkMode;
  bool get useHapticFeedback => _useHapticFeedback;
  bool get showMotivationalQuotes => _showMotivationalQuotes;
  String get distanceUnit => _distanceUnit;
  String get weightUnit => _weightUnit;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _prefs = await SharedPreferences.getInstance();
    _loadSettings();
    _isInitialized = true;
    notifyListeners();
  }

  void _loadSettings() {
    _isDarkMode = _prefs.getBool(_darkModeKey) ?? false;
    _useHapticFeedback = _prefs.getBool(_hapticFeedbackKey) ?? true;
    _showMotivationalQuotes = _prefs.getBool(_motivationalQuotesKey) ?? true;
    _distanceUnit = _prefs.getString(_distanceUnitKey) ?? 'km';
    _weightUnit = _prefs.getString(_weightUnitKey) ?? 'kg';
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool(_darkModeKey, _isDarkMode);
    notifyListeners();
  }

  Future<void> toggleHapticFeedback() async {
    _useHapticFeedback = !_useHapticFeedback;
    await _prefs.setBool(_hapticFeedbackKey, _useHapticFeedback);
    notifyListeners();
  }

  Future<void> toggleMotivationalQuotes() async {
    _showMotivationalQuotes = !_showMotivationalQuotes;
    await _prefs.setBool(_motivationalQuotesKey, _showMotivationalQuotes);
    notifyListeners();
  }

  Future<void> setDistanceUnit(String unit) async {
    if (unit != 'km' && unit != 'mi') return;
    _distanceUnit = unit;
    await _prefs.setString(_distanceUnitKey, unit);
    notifyListeners();
  }

  Future<void> setWeightUnit(String unit) async {
    if (unit != 'kg' && unit != 'lb') return;
    _weightUnit = unit;
    await _prefs.setString(_weightUnitKey, unit);
    notifyListeners();
  }
}