class FacultyModel {
  final String id;
  final String name;
  final String gender;
  final String phone;
  final String email;
  final String password;
  final List<String> courses;
  final List<String> subjects;
  final DateTime createdAt;
  final String role;

  FacultyModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.phone,
    required this.email,
    required this.password,
    required this.courses,
    required this.subjects,
    required this.createdAt,
    this.role = 'Faculty',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'phone': phone,
      'email': email,
      'password': password,
      'courses': courses,
      'subjects': subjects,
      'createdAt': createdAt.toIso8601String(),
      'role': role,
    };
  }

  factory FacultyModel.fromMap(Map<String, dynamic> map, String documentId) {
    return FacultyModel(
      id: documentId,
      name: map['name'] ?? '',
      gender: map['gender'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      courses: List<String>.from(map['courses'] ?? []),
      subjects: List<String>.from(map['subjects'] ?? []),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      role: map['role'] ?? 'Faculty',
    );
  }
}
