// lib/models/expense.dart
class Expense {
  final int? id;
  final DateTime date;
  final String description;
  final double amount;
  final String? notes;
  final int? ownerUserId;

  Expense({this.id, DateTime? date, required this.description, required this.amount, this.notes, this.ownerUserId}) : date = date ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'description': description,
        'amount': amount,
        'notes': notes,
        'owner_user_id': ownerUserId
      };

  factory Expense.fromMap(Map<String, dynamic> m) => Expense(
        id: m['id'] as int?,
        date: DateTime.parse(m['date'] as String),
        description: m['description'] as String,
        amount: (m['amount'] as num).toDouble(),
        notes: m['notes'] as String?,
        ownerUserId: m['owner_user_id'] as int?,
      );
}
