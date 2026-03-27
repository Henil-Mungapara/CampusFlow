
class CourseModel {
  final String id;
  final String code;
  final String name;
  final DateTime createdAt;
  final String departmentId;

  CourseModel({
    required this.id,
    required this.code,
    required this.name,
    required this.createdAt,
    required this.departmentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'departmentId': departmentId,
    };
  }

  factory CourseModel.fromMap(String id, Map<String, dynamic> map) {
    return CourseModel(
      id: id,
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now() : DateTime.now(),
      departmentId: map['departmentId'] ?? '',
    );
  }
}
