import 'package:flutter/material.dart';

class StudentController extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  // Mock State Data
  final double attendancePercentage = 85.4;
  final String attendanceStatus = "On Track";
  
  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // Future Firebase methods will go here
}
