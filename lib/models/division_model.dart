
class DivisionModel {
  final String id;
  final String code;
  final String name;
  final DateTime createdAt;
  final String courseId;

  DivisionModel({
    required this.id,
    required this.code,
    required this.name,
    required this.createdAt,
    required this.courseId,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'courseId': courseId,
    };
  }

  factory DivisionModel.fromMap(String id, Map<String, dynamic> map) {
    return DivisionModel(
      id: id,
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now() : DateTime.now(),
      courseId: map['courseId'] ?? '',
    );
  }
}
