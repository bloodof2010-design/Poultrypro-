// lib/models/labour.dart
class LabourEntry {
  final int? id;
  final DateTime date;
  final String description;
  final double hours;
  final double cost;
  final int? ownerUserId;

  LabourEntry({this.id, DateTime? date, required this.description, required this.hours, required this.cost, this.ownerUserId}) : date = date ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'description': description,
        'hours': hours,
        'cost': cost,
        'owner_user_id': ownerUserId
      };

  factory LabourEntry.fromMap(Map<String, dynamic> m) => LabourEntry(
        id: m['id'] as int?,
        date: DateTime.parse(m['date'] as String),
        description: m['description'] as String,
        hours: (m['hours'] as num).toDouble(),
        cost: (m['cost'] as num).toDouble(),
        ownerUserId: m['owner_user_id'] as int?,
      );
}
