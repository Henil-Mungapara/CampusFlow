import 'package:flutter/material.dart';

class FacultyController extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  // Mock State Data
  final int todayLectures = 3;
  final String nextClass = "CS-101 at 10:30 AM";
  final int pendingTasks = 4;
  final int completedTasks = 12;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // Future Firebase methods will go here
}
