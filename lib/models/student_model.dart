class StudentModel {
  final String id;
  final String name;
  final String enrollmentNumber;
  final String gender;
  final String phone;
  final String email;
  final String password;
  final String courseId;
  final String divisionId;
  final DateTime createdAt;
  final String role;

  StudentModel({
    required this.id,
    required this.name,
    required this.enrollmentNumber,
    required this.gender,
    required this.phone,
    required this.email,
    required this.password,
    required this.courseId,
    required this.divisionId,
    required this.createdAt,
    this.role = 'Student',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'enrollmentNumber': enrollmentNumber,
      'gender': gender,
      'phone': phone,
      'email': email,
      'password': password,
      'courseId': courseId,
      'divisionId': divisionId,
      'createdAt': createdAt.toIso8601String(),
      'role': role,
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map, String documentId) {
    return StudentModel(
      id: documentId,
      name: map['name'] ?? '',
      enrollmentNumber: map['enrollmentNumber'] ?? '',
      gender: map['gender'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      courseId: map['courseId'] ?? '',
      divisionId: map['divisionId'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      role: map['role'] ?? 'Student',
    );
  }
}
