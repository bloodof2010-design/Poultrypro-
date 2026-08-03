// lib/models/income.dart
class Income {
  final int? id;
  final DateTime date;
  final String source;
  final double amount;
  final String? notes;
  final int? ownerUserId;

  Income({this.id, DateTime? date, required this.source, required this.amount, this.notes, this.ownerUserId}) : date = date ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'source': source,
        'amount': amount,
        'notes': notes,
        'owner_user_id': ownerUserId
      };

  factory Income.fromMap(Map<String, dynamic> m) => Income(
        id: m['id'] as int?,
        date: DateTime.parse(m['date'] as String),
        source: m['source'] as String,
        amount: (m['amount'] as num).toDouble(),
        notes: m['notes'] as String?,
        ownerUserId: m['owner_user_id'] as int?,
      );
}
