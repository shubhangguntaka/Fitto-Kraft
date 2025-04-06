import 'package:flutter/foundation.dart';

class AppProvider with ChangeNotifier {
  // Fitness section
  String _selectedWorkoutType = 'Custom';
  List<Map<String, dynamic>> _customWorkouts = [];
  List<Map<String, dynamic>> _sportWorkouts = [];

  // Achievements section
  List<Map<String, dynamic>> _achievements = [];

  String get selectedWorkoutType => _selectedWorkoutType;
  List<Map<String, dynamic>> get customWorkouts => _customWorkouts;
  List<Map<String, dynamic>> get sportWorkouts => _sportWorkouts;
  List<Map<String, dynamic>> get achievements => _achievements;

  void setWorkoutType(String type) {
    _selectedWorkoutType = type;
    notifyListeners();
  }

  void addCustomWorkout(Map<String, dynamic> workout) {
    _customWorkouts.add(workout);
    notifyListeners();
  }

  void addSportWorkout(Map<String, dynamic> workout) {
    _sportWorkouts.add(workout);
    notifyListeners();
  }

  void addAchievement(Map<String, dynamic> achievement) {
    _achievements.add(achievement);
    notifyListeners();
  }

  // Initialize with some sample data
  void initializeData() {
    _customWorkouts = [
      {
        'title': 'Full Body Workout',
        'duration': '45 mins',
        'level': 'Beginner',
        'description': 'Complete body workout focusing on major muscle groups',
      },
      {
        'title': 'HIIT Training',
        'duration': '30 mins',
        'level': 'Intermediate',
        'description': 'High-intensity interval training for maximum fat burn',
      },
    ];

    _sportWorkouts = [
      {
        'title': 'Football Conditioning',
        'duration': '60 mins',
        'sport': 'Football',
        'description': 'Specific drills to improve football performance',
      },
      {
        'title': 'Basketball Agility',
        'duration': '45 mins',
        'sport': 'Basketball',
        'description': 'Enhance your court movement and reflexes',
      },
    ];

    _achievements = [
      {
        'title': 'First Milestone',
        'date': 'March 2025',
        'category': 'Running',
        'position': '1st Place',
      },
    ];
    
    notifyListeners();
  }
}