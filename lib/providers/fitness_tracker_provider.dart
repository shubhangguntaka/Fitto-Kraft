import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FitnessTrackerProvider with ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  int _steps = 0;
  double _distance = 0.0; // in kilometers
  int _calories = 0;
  int _activeMinutes = 0;

  // Getters
  int get steps => _steps;
  double get distance => _distance;
  int get calories => _calories;
  int get activeMinutes => _activeMinutes;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _prefs = await SharedPreferences.getInstance();
    _loadData();
    _isInitialized = true;
    notifyListeners();

    // Simulate data updates (in a real app, this would come from sensors/API)
    _startPeriodicUpdates();
  }

  void _loadData() {
    final now = DateTime.now();
    final today = '${now.year}-${now.month}-${now.day}';
    
    _steps = _prefs.getInt('steps_$today') ?? 0;
    _distance = _prefs.getDouble('distance_$today') ?? 0.0;
    _calories = _prefs.getInt('calories_$today') ?? 0;
    _activeMinutes = _prefs.getInt('active_minutes_$today') ?? 0;
  }

  Future<void> _saveData() async {
    final now = DateTime.now();
    final today = '${now.year}-${now.month}-${now.day}';
    
    await _prefs.setInt('steps_$today', _steps);
    await _prefs.setDouble('distance_$today', _distance);
    await _prefs.setInt('calories_$today', _calories);
    await _prefs.setInt('active_minutes_$today', _activeMinutes);
  }

  void _startPeriodicUpdates() {
    // Simulate data updates every minute
    Future.delayed(const Duration(minutes: 1), () {
      _updateData();
      _startPeriodicUpdates();
    });
  }

  void _updateData() {
    // Simulate activity (in a real app, this would come from sensors/API)
    final random = DateTime.now().millisecondsSinceEpoch % 100;
    
    _steps += random;
    _distance = _steps * 0.0007; // Rough estimate: 1 step ≈ 0.7 meters
    _calories = (_steps * 0.04).toInt(); // Rough estimate: 1 step ≈ 0.04 calories
    _activeMinutes = (_steps / 1000).round(); // Rough estimate: 1000 steps ≈ 10 minutes

    _saveData();
    notifyListeners();
  }

  void resetData() {
    _steps = 0;
    _distance = 0.0;
    _calories = 0;
    _activeMinutes = 0;
    _saveData();
    notifyListeners();
  }
}