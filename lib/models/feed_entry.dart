// lib/models/feed_entry.dart
class FeedEntry {
  final int? id;
  final int? birdId;
  final DateTime date;
  final String feedType;
  final double quantity;
  final String? notes;
  final int? ownerUserId;

  FeedEntry({this.id, this.birdId, DateTime? date, required this.feedType, required this.quantity, this.notes, this.ownerUserId}) : date = date ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'bird_id': birdId,
        'date': date.toIso8601String(),
        'feed_type': feedType,
        'quantity': quantity,
        'notes': notes,
        'owner_user_id': ownerUserId
      };

  factory FeedEntry.fromMap(Map<String, dynamic> m) => FeedEntry(
        id: m['id'] as int?,
        birdId: m['bird_id'] as int?,
        date: DateTime.parse(m['date'] as String),
        feedType: m['feed_type'] as String,
        quantity: (m['quantity'] as num).toDouble(),
        notes: m['notes'] as String?,
        ownerUserId: m['owner_user_id'] as int?,
      );
}
