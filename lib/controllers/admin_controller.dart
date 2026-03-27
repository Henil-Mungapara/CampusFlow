import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/department_model.dart';
import '../models/course_model.dart';
import '../models/division_model.dart';
import '../models/subject_model.dart';
import '../models/faculty_model.dart';
import '../models/student_model.dart';

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

  // Firestore references
  final CollectionReference _departmentsRef =
      FirebaseFirestore.instance.collection('departments');
  final CollectionReference _coursesRef =
      FirebaseFirestore.instance.collection('courses');
  final CollectionReference _divisionsRef =
      FirebaseFirestore.instance.collection('divisions');
  final CollectionReference _subjectsRef =
      FirebaseFirestore.instance.collection('subjects');
  final CollectionReference _facultyRef =
      FirebaseFirestore.instance.collection('faculty');
  final CollectionReference _studentsRef =
      FirebaseFirestore.instance.collection('students');

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // ─── Setup Generic Stream & Delete ────────────────────────────────────────

  Stream<List<Map<String, dynamic>>> getSetupItemsStream(String type) {
    if (type == 'Department') {
      return _departmentsRef.orderBy('name').snapshots().map((snapshot) => snapshot.docs.map((doc) => {'id': doc.id, 'name': (doc.data() as Map<String, dynamic>)['name'] ?? '', 'code': (doc.data() as Map<String, dynamic>)['code'] ?? '', 'foreignId': ''}).toList());
    } else if (type == 'Course') {
      return _coursesRef.orderBy('name').snapshots().map((snapshot) => snapshot.docs.map((doc) => {'id': doc.id, 'name': (doc.data() as Map<String, dynamic>)['name'] ?? '', 'code': (doc.data() as Map<String, dynamic>)['code'] ?? '', 'foreignId': (doc.data() as Map<String, dynamic>)['departmentId'] ?? ''}).toList());
    } else if (type == 'Division') {
      return _divisionsRef.orderBy('name').snapshots().map((snapshot) => snapshot.docs.map((doc) => {'id': doc.id, 'name': (doc.data() as Map<String, dynamic>)['name'] ?? '', 'code': (doc.data() as Map<String, dynamic>)['code'] ?? '', 'foreignId': (doc.data() as Map<String, dynamic>)['courseId'] ?? ''}).toList());
    } else if (type == 'Subject') {
      return _subjectsRef.orderBy('name').snapshots().map((snapshot) => snapshot.docs.map((doc) => {'id': doc.id, 'name': (doc.data() as Map<String, dynamic>)['name'] ?? '', 'code': (doc.data() as Map<String, dynamic>)['code'] ?? '', 'foreignId': (doc.data() as Map<String, dynamic>)['divisionId'] ?? ''}).toList());
    }
    return Stream.value([]);
  }

  Stream<int> getSetupCountStream(String type) {
    if (type == 'Departments') return _departmentsRef.snapshots().map((s) => s.docs.length);
    if (type == 'Courses') return _coursesRef.snapshots().map((s) => s.docs.length);
    if (type == 'Divisions') return _divisionsRef.snapshots().map((s) => s.docs.length);
    if (type == 'Subjects') return _subjectsRef.snapshots().map((s) => s.docs.length);
    return Stream.value(0);
  }

  Stream<int> getUserCountStream(String type) {
    if (type == 'Faculty') return _facultyRef.snapshots().map((s) => s.docs.length);
    if (type == 'Students') return _studentsRef.snapshots().map((s) => s.docs.length);
    return Stream.value(0);
  }

  Future<void> deleteSetupItem(String type, String id) async {
    if (type == 'Department') {
      await _departmentsRef.doc(id).delete();
    } else if (type == 'Course') {
      await _coursesRef.doc(id).delete();
    } else if (type == 'Division') {
      await _divisionsRef.doc(id).delete();
    } else if (type == 'Subject') {
      await _subjectsRef.doc(id).delete();
    }
  }

  // ─── Department Methods ───────────────────────────────────────────────

  Future<bool> isDepartmentCodeExists(String code) async {
    final doc = await _departmentsRef.doc(code.trim().toUpperCase()).get();
    return doc.exists;
  }

  Future<String?> addDepartment({
    required String code,
    required String name,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final exists = await isDepartmentCodeExists(code);
      if (exists) {
        _isLoading = false;
        notifyListeners();
        return 'Department code "${code.trim().toUpperCase()}" already exists!';
      }

      final docId = code.trim().toUpperCase();

      final department = DepartmentModel(
        id: docId,
        code: docId,
        name: name.trim(),
        createdAt: DateTime.now(),
      );

      await _departmentsRef.doc(docId).set(department.toMap());

      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Failed to save: ${e.toString()}';
    }
  }

  Future<String?> updateDepartment({required String code, required String name}) async {
    try {
      _isLoading = true; notifyListeners();
      await _departmentsRef.doc(code).update({'name': name.trim()});
      _isLoading = false; notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false; notifyListeners();
      return 'Failed to update: ${e.toString()}';
    }
  }

  Future<List<DepartmentModel>> fetchDepartments() async {
    final snapshot = await _departmentsRef.orderBy('name').get();
    return snapshot.docs
        .map((doc) =>
            DepartmentModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  // ─── Course Methods ───────────────────────────────────────────────────

  Future<bool> isCourseCodeExists(String code) async {
    final doc = await _coursesRef.doc(code.trim().toUpperCase()).get();
    return doc.exists;
  }

  Future<String?> addCourse({
    required String code,
    required String name,
    required String departmentId,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final exists = await isCourseCodeExists(code);
      if (exists) {
        _isLoading = false;
        notifyListeners();
        return 'Course code "${code.trim().toUpperCase()}" already exists!';
      }

      final docId = code.trim().toUpperCase();

      final course = CourseModel(
        id: docId,
        code: docId,
        name: name.trim(),
        createdAt: DateTime.now(),
        departmentId: departmentId,
      );

      await _coursesRef.doc(docId).set(course.toMap());

      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Failed to save: ${e.toString()}';
    }
  }

  Future<String?> updateCourse({required String code, required String name, required String departmentId}) async {
    try {
      _isLoading = true; notifyListeners();
      await _coursesRef.doc(code).update({'name': name.trim(), 'departmentId': departmentId});
      _isLoading = false; notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false; notifyListeners();
      return 'Failed to update: ${e.toString()}';
    }
  }

  Future<List<CourseModel>> fetchCourses() async {
    final snapshot = await _coursesRef.orderBy('name').get();
    return snapshot.docs
        .map((doc) =>
            CourseModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  // ─── Division Methods ─────────────────────────────────────────────────

  Future<bool> isDivisionCodeExists(String code) async {
    final doc = await _divisionsRef.doc(code.trim().toUpperCase()).get();
    return doc.exists;
  }

  Future<String?> addDivision({
    required String code,
    required String name,
    required String courseId,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final exists = await isDivisionCodeExists(code);
      if (exists) {
        _isLoading = false;
        notifyListeners();
        return 'Division code "${code.trim().toUpperCase()}" already exists!';
      }

      final docId = code.trim().toUpperCase();

      final division = DivisionModel(
        id: docId,
        code: docId,
        name: name.trim(),
        createdAt: DateTime.now(),
        courseId: courseId,
      );

      await _divisionsRef.doc(docId).set(division.toMap());

      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Failed to save: ${e.toString()}';
    }
  }

  Future<String?> updateDivision({required String code, required String name, required String courseId}) async {
    try {
      _isLoading = true; notifyListeners();
      await _divisionsRef.doc(code).update({'name': name.trim(), 'courseId': courseId});
      _isLoading = false; notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false; notifyListeners();
      return 'Failed to update: ${e.toString()}';
    }
  }

  Future<List<DivisionModel>> fetchDivisions() async {
    final snapshot = await _divisionsRef.orderBy('name').get();
    return snapshot.docs
        .map((doc) =>
            DivisionModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  // ─── Subject Methods ──────────────────────────────────────────────────

  Future<bool> isSubjectCodeExists(String code) async {
    final doc = await _subjectsRef.doc(code.trim().toUpperCase()).get();
    return doc.exists;
  }

  Future<String?> addSubject({
    required String code,
    required String name,
    required String divisionId,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final exists = await isSubjectCodeExists(code);
      if (exists) {
        _isLoading = false;
        notifyListeners();
        return 'Subject code "${code.trim().toUpperCase()}" already exists!';
      }

      final docId = code.trim().toUpperCase();

      final subject = SubjectModel(
        id: docId,
        code: docId,
        name: name.trim(),
        divisionId: divisionId,
        createdAt: DateTime.now(),
      );

      await _subjectsRef.doc(docId).set(subject.toMap());

      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Failed to save: ${e.toString()}';
    }
  }

  Future<String?> updateSubject({required String code, required String name, required String divisionId}) async {
    try {
      _isLoading = true; notifyListeners();
      await _subjectsRef.doc(code).update({'name': name.trim(), 'divisionId': divisionId});
      _isLoading = false; notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false; notifyListeners();
      return 'Failed to update: ${e.toString()}';
    }
  }

  // ─── Registration Methods ──────────────────────────────────────────────

  Future<String?> registerFaculty({
    required String name,
    required String gender,
    required String phone,
    required String email,
    required String password,
    required List<String> courses,
    required List<String> subjects,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Check if email already exists
      final query = await _facultyRef.where('email', isEqualTo: email.trim()).get();
      if (query.docs.isNotEmpty) {
        _isLoading = false;
        notifyListeners();
        return 'Email already registered as Faculty.';
      }

      final docRef = _facultyRef.doc();
      final docId = docRef.id;

      final faculty = FacultyModel(
        id: docId,
        name: name.trim(),
        gender: gender,
        phone: phone.trim(),
        email: email.trim(),
        password: password, // In production, hash passwords
        courses: courses,
        subjects: subjects,
        createdAt: DateTime.now(),
      );

      await docRef.set(faculty.toMap());

      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Failed to register faculty: ${e.toString()}';
    }
  }

  Future<String?> registerStudent({
    required String name,
    required String enrollmentNumber,
    required String gender,
    required String phone,
    required String email,
    required String password,
    required String courseId,
    required String divisionId,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Check if enrollment number or email already exists
      final queryEnrollment = await _studentsRef.where('enrollmentNumber', isEqualTo: enrollmentNumber.trim()).get();
      if (queryEnrollment.docs.isNotEmpty) {
        _isLoading = false;
        notifyListeners();
        return 'Enrollment Number already exists.';
      }

      final queryEmail = await _studentsRef.where('email', isEqualTo: email.trim()).get();
      if (queryEmail.docs.isNotEmpty) {
        _isLoading = false;
        notifyListeners();
        return 'Email already registered as Student.';
      }

      final docRef = _studentsRef.doc();
      final docId = docRef.id;

      final student = StudentModel(
        id: docId,
        name: name.trim(),
        enrollmentNumber: enrollmentNumber.trim(),
        gender: gender,
        phone: phone.trim(),
        email: email.trim(),
        password: password, // In production, hash passwords
        courseId: courseId,
        divisionId: divisionId,
        createdAt: DateTime.now(),
      );

      await docRef.set(student.toMap());

      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Failed to register student: ${e.toString()}';
    }
  }
}
