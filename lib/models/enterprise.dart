// name=lib/models/enterprise.dart
import 'dart:convert';

enum EnterpriseType { hens, cattle }

String enterpriseTypeToString(EnterpriseType t) {
  switch (t) {
    case EnterpriseType.hens:
      return 'hens';
    case EnterpriseType.cattle:
      return 'cattle';
  }
}

EnterpriseType enterpriseTypeFromString(String s) {
  switch (s) {
    case 'hens':
      return EnterpriseType.hens;
    case 'cattle':
      return EnterpriseType.cattle;
    default:
      return EnterpriseType.hens;
  }
}

class Enterprise {
  final String id;
  final EnterpriseType type;
  final String name;
  final DateTime dateCreated;
  final String? notes;

  Enterprise({
    required this.id,
    required this.type,
    required this.name,
    required this.dateCreated,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': enterpriseTypeToString(type),
        'name': name,
        'dateCreated': dateCreated.toIso8601String(),
        'notes': notes,
      };

  factory Enterprise.fromJson(Map<String, dynamic> json) {
    return Enterprise(
      id: json['id'] as String,
      type: enterpriseTypeFromString(json['type'] as String),
      name: json['name'] as String,
      dateCreated: DateTime.parse(json['dateCreated'] as String),
      notes: json['notes'] as String?,
    );
  }

  static List<Enterprise> listFromJsonString(String encoded) {
    final List<dynamic> arr = json.decode(encoded) as List<dynamic>;
    return arr.map((e) => Enterprise.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String listToJsonString(List<Enterprise> list) {
    final arr = list.map((e) => e.toJson()).toList();
    return json.encode(arr);
  }
}
