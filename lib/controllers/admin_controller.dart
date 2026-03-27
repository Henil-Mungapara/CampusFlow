import 'package:flutter/material.dart';

class AdminController extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  // Mock State Data
  final int totalStudents = 1240;
  final int totalFaculty = 48;
  final int activeNotices = 12;
  final int upcomingEvents = 3;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // Future Firebase methods will go here
}
