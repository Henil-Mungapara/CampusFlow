import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectModel {
  final String id;
  final String code;
  final String name;
  final String divisionId;
  final DateTime createdAt;

  SubjectModel({
    required this.id,
    required this.code,
    required this.name,
    required this.divisionId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'divisionId': divisionId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory SubjectModel.fromMap(String id, Map<String, dynamic> map) {
    return SubjectModel(
      id: id,
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      divisionId: map['divisionId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
