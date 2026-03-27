import 'package:cloud_firestore/cloud_firestore.dart';

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
      'createdAt': Timestamp.fromDate(createdAt),
      'courseId': courseId,
    };
  }

  factory DivisionModel.fromMap(String id, Map<String, dynamic> map) {
    return DivisionModel(
      id: id,
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      courseId: map['courseId'] ?? '',
    );
  }
}
