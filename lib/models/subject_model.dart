
class SubjectModel {
  final String id;
  final String code;
  final String courseId;
  final DateTime createdAt;

  SubjectModel({
    required this.id,
    required this.code,
    required this.courseId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'courseId': courseId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SubjectModel.fromMap(String id, Map<String, dynamic> map) {
    return SubjectModel(
      id: id,
      code: map['code'] ?? '',
      courseId: map['courseId'] ?? '',
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now() : DateTime.now(),
    );
  }
}
