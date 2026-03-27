import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentModel {
  final String id;
  final String code;
  final String name;
  final DateTime createdAt;

  DepartmentModel({
    required this.id,
    required this.code,
    required this.name,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory DepartmentModel.fromMap(String id, Map<String, dynamic> map) {
    return DepartmentModel(
      id: id,
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
