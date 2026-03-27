import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/department_model.dart';

class AdminController extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  // Mock State Data
  final int totalStudents = 1240;
  final int totalFaculty = 48;
  final int activeNotices = 12;
  final int upcomingEvents = 3;

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Firestore reference
  final CollectionReference _departmentsRef =
      FirebaseFirestore.instance.collection('departments');

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  /// Check if a department code already exists in Firestore
  Future<bool> isDepartmentCodeExists(String code) async {
    final snapshot = await _departmentsRef
        .where('code', isEqualTo: code.trim().toUpperCase())
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  /// Add a new department to Firestore
  Future<String?> addDepartment({
    required String code,
    required String name,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Check for duplicate code
      final exists = await isDepartmentCodeExists(code);
      if (exists) {
        _isLoading = false;
        notifyListeners();
        return 'Department code "${code.trim().toUpperCase()}" already exists!';
      }

      // Create the model
      final department = DepartmentModel(
        id: '',
        code: code.trim().toUpperCase(),
        name: name.trim(),
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await _departmentsRef.add(department.toMap());

      _isLoading = false;
      notifyListeners();
      return null; // success
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Failed to save: ${e.toString()}';
    }
  }
}
